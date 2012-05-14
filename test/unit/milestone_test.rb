require 'test_helper'

class MilestoneTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # Attempt test milestones belongs to project and project has many milestones
  test "attempt with milestones" do
  	p1 = Project.create(:name => "proj1")
  	assert_not_nil(p1)
  	p2 = Project.create(:name => "proj2")
	assert_not_nil(p2)
  	assert_empty p1.milestones
  	assert_empty p2.milestones
  	miles1 = p1.milestones.create(:name => "somemilestone", :project_id => p2.id)
  	
  	puts miles1.name
  	puts p1.name
  	puts p2.name
  	puts p1.id
  	puts p2.id
  	puts p1.milestones.name
  	puts p1.milestones.size
  	puts p2.milestones.name
  	puts p2.milestones.size
  	
  	assert_equal 1, p2.milestones(true).size
  	assert_equal 1, p2.reload.milestones.size
  	assert_equal 1, p2.milestones.size
  end
end
