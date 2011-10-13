class RenameOwnerId < ActiveRecord::Migration
  def self.up
    add_column :items, :user_id, :integer
    remove_column :items, :owner_id

    remove_index :items, :name => :index_items_on_owner_id rescue ActiveRecord::StatementInvalid
    add_index :items, [:user_id]
  end

  def self.down
    remove_column :items, :user_id
    add_column :items, :owner_id, :integer

    remove_index :items, :name => :index_items_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :items, [:owner_id]
  end
end
