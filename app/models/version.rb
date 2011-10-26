class Version < ActiveRecord::Base

  # Versions should only be updated or created via vestal
  # versions, and never via this model
  def readonly?
    true
  end
end
