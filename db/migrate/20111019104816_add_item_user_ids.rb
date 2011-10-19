class AddItemUserIds < ActiveRecord::Migration
  def self.up
    add_column :item_users, :user_id, :integer
    add_column :item_users, :item_id, :integer

    add_index :item_users, [:user_id]
    add_index :item_users, [:item_id]
  end

  def self.down
    remove_column :item_users, :user_id
    remove_column :item_users, :item_id

    remove_index :item_users, :name => :index_item_users_on_user_id rescue ActiveRecord::StatementInvalid
    remove_index :item_users, :name => :index_item_users_on_item_id rescue ActiveRecord::StatementInvalid
  end
end
