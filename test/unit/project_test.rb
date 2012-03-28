require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  # Test creation and initialization by default.
  test "Check creation an initialization Project by default" do
    # Creating a new default lane.
    default_project = Project.new
    default_project.save
    assert_not_nil(default_project, "Expected that project is not null")
		
    # Test that default values were used.
    assert_equal(nil, default_project.name)
    assert_equal(nil, default_project.details)
    assert_equal("running", default_project.state)
    
    # Test that it is possible to delete the project.
    assert default_project.destroy
    assert_nil(default_project,"Expected that project was destroyed")
  end

  # Setup a Project to use in this test. 
  setup do
    Project.delete_all #delete previous Projects
    @oneProjectUnit = Project.create( :name    => "Project Unit Test",
                                      :details => "Test creates in Unit Test")
    assert_not_nil(@oneProjectUnit)
    
    # Check that is the unique project create into db.
    assert_equal(1, Project.count)
  end
  
  # Test creation and initialization with values.
  test "Check creation an initialization Project with values" do
    assert_not_nil(@oneProjectUnit, "project is not null")
    
    # test that default values were used
    assert_equal("Project Unit Test",@oneProjectUnit.name)
    assert_equal("Test creates in Unit Test",@oneProjectUnit.details)
    assert_equal("running",@oneProjectUnit.state) # value by default, modify
                                                  # by lifecycle.
    assert_not_nil(@oneProjectUnit.created_at) # check timestamp.
    assert_not_nil(@oneProjectUnit.updated_at) # check timestamp.
    assert_not_nil(@oneProjectUnit.key_timestamp,
                   "Expected that key_timestamp was not null") # NULL??
  end

  # Test Update.
  test "Check updating Project with values" do
    @oneProjectUnit.update_attributes( :name    => "Updated name",
                                       :details => "Updating project in U.T.",
                                       :state => "update state" )
    assert_equal("Updated name", @oneProjectUnit.name)
    assert_equal("Updating project in U.T.", @oneProjectUnit.details)
    assert_not_equal("update state", @oneProjectUnit.state)
    assert_not_nil(@oneProjectUnit.created_at) # check timestamp.
    assert_not_nil(@oneProjectUnit.updated_at) # check timestamp.
    assert_not_nil(@oneProjectUnit.key_timestamp) # NULL??
    
    # Test update a field and save.
    @oneProjectUnit.name = "Updated name once again"
    assert @oneProjectUnit.save
    assert_equal("Updated name once again", @oneProjectUnit.name)
  end
  
	
  # Test that the fields of project can be Readables/Writables. 
 	# Note*: write does not invoke the model based validation !!
  test "Check that every field from project can be read/write" do
    
    assert_nothing_raised { @oneProjectUnit.name } # not expect any exception.
    assert_nothing_raised { @oneProjectUnit.name = "write name" }  
    
    assert_nothing_raised { @oneProjectUnit.details } 
    assert_nothing_raised { @oneProjectUnit.details = "write details" } 
    
    assert_nothing_raised { @oneProjectUnit.state } 
    assert_nothing_raised { @oneProjectUnit.state = "write state" } 
    assert_equal("write state", @oneProjectUnit.state) # it's work, see Note*
    
    assert_nothing_raised { @oneProjectUnit.created_at } 
    assert_nothing_raised { @oneProjectUnit.created_at = 0 } 
    
    assert_nothing_raised { @oneProjectUnit.updated_at } 
    assert_nothing_raised { @oneProjectUnit.updated_at = 0 } 
    
    assert_nothing_raised { @oneProjectUnit.key_timestamp } 
    assert_nothing_raised { @oneProjectUnit.key_timestamp = 0 } 
            
    flunk ("Write does not invoke the model validation !!")
    
  end
  
  # Test the name validation. 
  test "Check that name is shorter than 50 characters" do
    assert_required_length_less_than(@oneProjectUnit, :name, 50)
  end
	
  test "Check that name is longer than 4 characters" do
    assert_required_length_more_than(@oneProjectUnit, :name, 4)
  end
  
  # Test Project has many :items.
  test "Check that Project has many items" do
    # Check through class definition
    reflection_items = @oneProjectUnit.class.reflect_on_association(:items)
    assert_not_nil(reflection_items, "Project is not associated to items")
    assert_equal(reflection_items.macro, :has_many, 
                "Project doesn't have any items")
                
    # Check through creation and association lanes to one project
    projectHasItems = Project.create(:name => "projectHasItems")
    projectHasItems.save
    assert_not_nil(projectHasItems)
    assert_empty projectHasItems.items
    
    itemProject1 = projectHasItems.items.build( :title => "item1inProject",
                                                :project_id => 
                                                           projectHasItems.id )
    assert_not_nil(itemProject1)
    
    itemProject2 = projectHasItems.items.build( :title => "item2inProject",
                                                :project_id => 
                                                           projectHasItems.id )
    assert_not_nil(itemProject2)
    assert_equal(2, projectHasItems.items.size)
    
  end
  
  # Test Project has many :lanes.
  test "Check that Project has many lanes" do
    reflection_lanes = @oneProjectUnit.class.reflect_on_association(:lanes)
    assert_not_nil(reflection_lanes, "Project is not associated to lanes")
    assert_equal(reflection_lanes.macro, :has_many, 
                 "Project doesn't have any lanes")
    
    # Check through creation and association lanes to one project
    projectHasLanes = Project.create(:name => "projectHasLanes")
    projectHasLanes.save
    assert_not_nil(projectHasLanes)
    assert_empty(projectHasLanes.lanes)
    
    laneProject1 = projectHasLanes.lanes.build( :title => "lane1inProject", 
  	                                           :project_id => 
  	                                                      projectHasLanes.id )
    laneProject1.save
    assert_not_nil(laneProject1)
    
    laneProject2 = projectHasLanes.lanes.build( :title => "lane2inProject", 
                                                :project_id => 
                                                           projectHasLanes.id )
    laneProject2.save
    assert_not_nil(laneProject2)
    
    assert_equal(2, projectHasLanes.lanes.size)
    
  end
  
  # Test Project has many :project_members.
  test "Check that Project has many project_members" do
    reflection_project_members = 
                 @oneProjectUnit.class.reflect_on_association(:project_members)
    assert_not_nil(reflection_project_members, 
                   "Project is not associated to items")
    assert_equal(reflection_project_members.macro, :has_many, 
                "Project doesn't have any project_members")
  end
  
  # Test Project has many :users.
  test "Check that Project has many users" do
    # Check through class definition
    reflection_users = @oneProjectUnit.class.reflect_on_association(:users)
    assert_not_nil(reflection_users, "Project is not associated to users")
    assert_equal(reflection_users.macro, :has_many, 
                "Project doesn't have any users")
  end
  
  # Check through creation and association users to one project 
  # (project members)
  test "Check that one Project could have many users (project members)" do
  	
  	admin = User.create(:name => "adminuser",
  	                    :administrator => true)
  	admin.save
  	assert_not_nil(admin,"Administrator create and save")
  	
  	not_admin = User.create(:name => "not_admin",
  	                        :administrator => false)
  	not_admin.save
	assert_not_nil(not_admin,"Non administrator create and save")
	
  	project_admin = admin.projects.build(:name => "admin_project")
  	project_admin.save
  	assert_not_nil(project_admin)
  	
  	member_admin = admin.project_members.build( :administrator => true,
  	                                            :project_id => 
  	                                                         project_admin.id,
  	                                            :user_id => admin.id)
  	member_admin.save
  	assert member_admin
  	
  	member_not_admin = admin.project_members.build( :administrator => true,
  	                                                :project_id => 
  	                                                         project_admin.id,
  	                                                :user_id => not_admin.id )
  	member_not_admin.save
  	assert member_not_admin
	
  	assert_equal(2, project_admin.project_members.size)
  	
  end
  
  # Test Project has many :milestones
  test "Check that Project has many milestones" do
  
    # Check through class definition
    reflection_milestones = 
                      @oneProjectUnit.class.reflect_on_association(:milestones)
    assert_not_nil(reflection_milestones, 
                   "Project is not associated to milestones")
    assert_equal(reflection_milestones.macro, :has_many, 
                "Project doesn't have any milestones")
                
    # Check through creation and association milestones to one project
    projectHasMilestones = Project.create(:name => "proMilUnit")
    projectHasMilestones.save
    assert_not_nil(projectHasMilestones)
    assert_empty projectHasMilestones.milestones
    
    milestoneProject1 = projectHasMilestones.milestones.create( 
                                                     :name => "mileston1inPro", 
  	                                                :project_id => 
  	                                                 projectHasMilestones.id )
    assert_not_nil(milestoneProject1)
    milestoneProject2 = projectHasMilestones.milestones.create( 
                                                :name => "milestone2inPro", 
                                                :project_id => 
                                                      projectHasMilestones.id )
    assert_not_nil(milestoneProject2)
    assert_equal(2, projectHasMilestones.milestones.size)
    
  end
  

 end
