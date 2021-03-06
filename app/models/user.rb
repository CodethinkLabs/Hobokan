class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    if user.is_a?(User)
      Thread.current[:user] = user
    end
  end

  fields do
    name          :string, :required, :unique
    email_address :email_address, :login => true
    administrator :boolean, :default => false
    role enum_string(:client, :sales, :developer, :manager, :inactive)
    timestamps
  end

  has_many :project_members, :accessible => true
  has_many :projects, :through => :project_members
  default_scope :order => 'name ASC'

  # This gives admin rights and an :active state to the first sign-up.
  # Just remove it if you don't want that
  before_create do |user|
    if !Rails.env.test? && user.class.count == 0
      user.administrator = true
      user.state = "active"
    end
  end

  def validate_password
    if new_password_required?
      validates_length_of :password, :within => 6..40
    end
  end

  def new_password_required_with_invite_only?
    new_password_required_without_invite_only? || self.class.count==0
  end
  alias_method_chain :new_password_required?, :invite_only

  def versions
    v = Version.arel_table
    #this is a nasty hack - item.position changes so often it clutters the log - so only take changes with an "e" in the field!?
    return Version.where(v[:modifications].matches("%lane_id%")).order("created_at DESC").limit(200)
  end

  def items
    logger.debug("User#items #{project_members.map {|member| member.items}.flatten.inspect}")
    project_members.map {|member| member.items}.flatten
  end

  # --- Signup lifecycle --- #

  lifecycle do

    state :invited, :default => true
    state :active
    state :inactive

    create :invite,
           :available_to => "acting_user if acting_user.administrator?",
           :subsite => "admin",
           :params => [:name, :email_address],
           :new_key => true,
           :become => :invited do
       UserMailer.invite(self, lifecycle.key).deliver
    end

    transition :accept_invitation, { :invited => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.forgot_password(self, lifecycle.key).deliver
    end

    transition :request_password_reset, { :invited => :invited }, :new_key => true do
      UserMailer.invite(self, lifecycle.key).deliver
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

    transition :deactivate, { :active => :inactive }, :available_to => "User.administrator" do
      self.email_address = Date.today.to_s + self.email_address
      self.save
    end


  end

  def signed_up?
    state=="active"
  end

  # --- Permissions --- #

  def create_permitted?
    # Only the initial admin user can be created
    self.class.count == 0
  end

  def update_permitted?
    acting_user.administrator? ||
      (acting_user == self && only_changed?(:email_address, :crypted_password,
                                            :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user == self || acting_user.administrator? || self.state == "invited" || :key_holder
  end
end
