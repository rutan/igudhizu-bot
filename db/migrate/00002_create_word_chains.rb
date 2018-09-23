class CreateWordChains < ActiveRecord::Migration[5.2]
  def change
    create_table :word_chains do |t|
      t.references :head, index: true, null: true, foreign_key: {to_table: :words}
      t.references :body, index: true, null: true, foreign_key: {to_table: :words}
      t.references :foot, index: true, null: true, foreign_key: {to_table: :words}
      t.timestamps null: false
    end
    add_index :word_chains, [:head_id, :body_id, :foot_id], unique: true
  end
end