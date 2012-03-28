require 'test_helper'

class LaneTest < ActiveSupport::TestCase

  setup do
    Lane.delete_all
    Project.delete_all
    Milestone.delete_all
    ProjectMember.delete_all
    # Create one Admin.
    @oneAdmin = User.create( :name => "oneAdmin name",
                             :email_address => "oneAdmin@oneAdmin.com",
                             :administrator => true,
                             :role => :manager )
    # Create one User.
    @oneUser = User.create( :name => "oneUser name",
                            :email_address => "oneUser@oneUser.com",
                            :administrator => true,
                            :role => :manager )
    
    # Create one Project.
    @oneProject = Project.create( :name => "Project Unit Test",
                                  :details => "project for lane unit testing" )

    assert_not_nil(@oneProject, "Expected created project was not nil")
    
    # Create a Lane associated to the project.      
    @oneLane = @oneProject.lanes.create( :title => "Lane Unit Test", 
                                         :position => -1, 
                                         :background_color => "black", 
                                         :color => '#FFFFFF',
                                         :todo => false,
                                         :project => @oneProject )
    assert_not_nil(@oneLane, "Expected created lane was not nil")
    
    # Check that is the unique lane create into db.
    assert_equal(1, Lane.count, "Expected lane created was unique")
    
    # Check that the unique lane created is our lane
    @secondLane = Lane.find(:first, :conditions => ["color = '#FFFFFF'"])
    assert_equal(@secondLane.title, "Lane Unit Test", 
                 "Expected lane in db was the lane created")
                 
    # Create Milestones associated to the project
    @oneMilestone = @oneProject.milestones.create(
                                   :name => "first milestone",
                                   :description => 
                                         "first milestone for lane unit test",
                                   :project => @oneProject )
    assert_not_nil(@oneMilestone, "Expected milestone was created")
    
    @twoMilestone = @oneProject.milestones.create(
                                  :name => "second milestone",
                                  :description => 
                                          "second milestone for lane unit test",
                                  :project => @oneProject )
    assert_not_nil(@twoMilestone, "Expected milestone was created")
      
  end
	
  # Test for function name.
  test "Check function name" do
    nameOne = @oneLane.name
    assert_equal(nameOne, @oneLane.title, "Expected name is equal to title")
  end
  
  # Test for the function milestones.
  test "Check that function 'milestones' return the milestones of the project 
        associated to a lane" do
        
    retMilestones = @oneLane.project.milestones
    assert_equal(2, retMilestones.size,
                "Expected two milestones associated to the project which is 
                 associated to the lane")
  end
  
  # Test for permissions.
    # Test for create.
      # Check creation without project_members (new project)
      test "Check create permission without project_members" do
        # Create a project
        notProjectMem = Project.create(:name => "without project Members")
        
        # Check that there are not any project member
        assert_equal(0, ProjectMember.count)
        
        # Create one lane
        notProjectMem_Lane = notProjectMem.lanes.create(
                                           :title => "without project Members",
                                           :project => notProjectMem)
        
        assert(notProjectMem_Lane.creatable_by?(@oneUser), 
          "Expected @oneUser can create one lane at beginning of the project.")
      end
      
      # Check creation with project_members being admin of the project
      test "Check create permission with project_members" do
        # Create a project.
        aProject = Project.create!( :name => "Testing permsision create",
                                    :details => "project for lane permission" )
        aProject2 = Project.create!( :name => "Testing permsision create",
                                     :details => "idem for project 2" )
        # Create an admin.
        aAdmin = User.create!( :name => "oneUser name",
                               :email_address => "oneUser@oneUser.com",
                               :password => "password",
                               :administrator => true,
                               :role => :manager )
        aUser = User.create!(  :name => "twoUser name",
                               :email_address => "twoUser@twoUser.com",
                               :password => "password",
                               :administrator => false,
                               :role => :manager )
        # Associated the admin to the project --> membership
        aMembership = ProjectMember.create!( :project => aProject,
                                             :user => aAdmin )
        aMembership2 = ProjectMember.create!( :project => aProject2,
                                              :user => aUser,
                                              :administrator => false)
        # Check that there are two project members
        assert_equal(2, ProjectMember.count)
        
        # is the admin able to create a lane in the project?
        ProjectMember.memberships = []
        ProjectMember.admin_memberships = []
        ProjectMember.view_memberships = []

        members = ProjectMember.where(:user_id => aAdmin)
        
        puts members.size
        puts members[0].name
        puts Project.count
        
        members.each do |member|
          ProjectMember.memberships.push(member.project_id)
          ProjectMember.admin_memberships.push(member.project_id) unless !member.administrator
          ProjectMember.view_memberships.push(member.project_id)
        end
        
        puts "Lane#create_permitted? #{ProjectMember.admin_memberships.inspect} project_id: #{members[0].project_id}"
        puts "Lane#create_permitted? #{ProjectMember.memberships.inspect} project_id: #{members[0].project_id}"
        puts "Lane#create_permitted? #{ProjectMember.view_memberships.inspect} project_id: #{members[0].project_id}"
        # Check if the project has or not admin_memberships associated
         # aProject has an admin_membership because admin created it
         # aProject2 does not have an admin_membership because aUser created it
        
        assert(ProjectMember.admin_memberships.include?(aProject.id), "Expected that the project includes admin memberships")
        
        # Check that any user cannot create one lane in aProject2
        assert_equal(1, aProject2.project_members.count, 
                     "Expected one project member associated." )
        assert(!ProjectMember.admin_memberships.include?(aProject2.id), 
               "Expected that the project doesn't include admin memberships" )
         
        assert(!aProject2.lanes.create!(:title => "no lane created").creatable_by?(aAdmin),
               "Expected create fail because there aren't any admin_memberships")
        
      end

      # Check creation with project_members not being admin of the project
    # Test for update.
    # Test for destroy.
    # Test for view.

	
end
