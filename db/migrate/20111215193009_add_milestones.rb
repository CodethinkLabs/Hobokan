class AddMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.string   :name
      t.date     :date
      t.string   :background_color
      t.string   :color, :default => "#000000"
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_id
    end
    add_index :milestones, [:project_id]

    add_column :items, :milestone_id, :integer

    change_column :project_members, :administrator, :boolean, :default => true

    add_index :items, [:milestone_id]
  end

  def self.down
    remove_column :items, :milestone_id

    change_column :project_members, :administrator, :boolean, :default => false

    drop_table :milestones

    remove_index :items, :name => :index_items_on_milestone_id rescue ActiveRecord::StatementInvalid
  end
end
