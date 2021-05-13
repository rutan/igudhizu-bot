# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2) do

  create_table "word_chains", force: :cascade do |t|
    t.integer "head_id"
    t.integer "body_id"
    t.integer "foot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["body_id"], name: "index_word_chains_on_body_id"
    t.index ["foot_id"], name: "index_word_chains_on_foot_id"
    t.index ["head_id", "body_id", "foot_id"], name: "index_word_chains_on_head_id_and_body_id_and_foot_id", unique: true
    t.index ["head_id"], name: "index_word_chains_on_head_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "content", limit: 64, null: false
    t.string "word_type", limit: 16, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content", "word_type"], name: "index_words_on_content_and_word_type", unique: true
  end

  add_foreign_key "word_chains", "words", column: "body_id"
  add_foreign_key "word_chains", "words", column: "foot_id"
  add_foreign_key "word_chains", "words", column: "head_id"
end
