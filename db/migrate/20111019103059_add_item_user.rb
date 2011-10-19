class AddItemUser < ActiveRecord::Migration
  def self.up
    create_table :item_users do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end

    remove_column :items, :user_id

    remove_index :items, :name => :index_items_on_user_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :items, :user_id, :integer

    drop_table :item_users

    add_index :items, [:user_id]
  end
end
