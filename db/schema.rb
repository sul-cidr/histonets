# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170119132559) do

  create_table "collection_templates", force: :cascade do |t|
    t.integer  "collection_id"
    t.text     "crop_bounds"
    t.text     "image_clean"
    t.text     "image_paths"
    t.text     "image_graph"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "image_id"
    t.boolean  "auto_clean"
    t.index ["collection_id"], name: "index_collection_templates_on_collection_id"
    t.index ["image_id"], name: "index_collection_templates_on_image_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "year"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "collections_images", id: false, force: :cascade do |t|
    t.integer "collection_id"
    t.integer "image_id"
    t.index ["collection_id"], name: "index_collections_images_on_collection_id"
    t.index ["image_id"], name: "index_collections_images_on_image_id"
  end

  create_table "histograms", force: :cascade do |t|
    t.binary   "histogram"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "histogramable_type"
    t.integer  "histogramable_id"
    t.index ["histogramable_type", "histogramable_id"], name: "index_histograms_on_histogramable_type_and_histogramable_id"
  end

  create_table "image_templates", force: :cascade do |t|
    t.integer  "collection_template_id"
    t.string   "image_url"
    t.binary   "mask"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "status"
    t.text     "match_options"
    t.index ["collection_template_id"], name: "index_image_templates_on_collection_template_id"
  end

  create_table "images", force: :cascade do |t|
    t.string   "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_name"], name: "index_images_on_file_name", unique: true
  end

end
