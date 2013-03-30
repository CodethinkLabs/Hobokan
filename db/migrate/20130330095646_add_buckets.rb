class AddBuckets < ActiveRecord::Migration
  def self.up
    add_column :items, :bucket_id, :integer

    add_index :items, [:bucket_id]
  end

  def self.down
    remove_column :items, :bucket_id

    remove_index :items, :name => :index_items_on_bucket_id rescue ActiveRecord::StatementInvalid
  end
end
