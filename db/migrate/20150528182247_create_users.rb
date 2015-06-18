  class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password
      t.string :password_digest
      t.integer :level, default: 1
      t.boolean :activation_status, default: false
      t.string :activation_token

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
