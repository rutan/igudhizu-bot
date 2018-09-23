class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :content, null: false, limit: 64
      t.string :word_type, null: false, limit: 16
      t.timestamps null: false
    end
    add_index :words, [:content, :word_type], unique: true
  end
end