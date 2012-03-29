ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Helper methods to test that the length of a field is valid 
  def assert_required_length_less_than(object, field, length)
    
    dup_object = object.clone		
        
    # Invalid at length-1
    dup_object.send("#{field}=", "a"*(length-1))
    assert(dup_object.valid?)
		
    # Valid at length
    dup_object.send("#{field}=", "a"*length)
    assert(dup_object.valid?)
	
    # Invalid at length+1
    dup_object.send("#{field}=", "a"*(length+1))
    assert(dup_object.valid?, 
           "Expected validation error: string must be shorter than #{length} characters.")
    end


    def assert_required_length_more_than(object, field, length)
      
      dup_object = object.clone		
      
      # Invalid at length-1
      dup_object.send("#{field}=", "a"*(length-1))
      assert(dup_object.valid?,
             "Expected validation error: string must be longer than #{length} characters.")

      # Valid at length
      dup_object.send("#{field}=", "a"*length)
      assert(dup_object.valid?)
	
      # Invalid at length+1
      dup_object.send("#{field}=", "a"*(length+1))
      assert(dup_object.valid?)
    end
	
end
