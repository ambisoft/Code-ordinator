class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title, index: true
      t.text :content
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
