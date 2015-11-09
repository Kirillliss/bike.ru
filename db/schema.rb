# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150629161958) do

  create_table "banners", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "image"
    t.boolean  "topable",    default: true
    t.boolean  "leftable",   default: false
    t.boolean  "published",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price_of_shipping", default: 0.0
    t.string   "kind_of_shipping"
    t.integer  "city_code"
    t.string   "city_title"
    t.integer  "region_code"
    t.string   "region_title"
  end

  create_table "categories", force: true do |t|
    t.string   "title"
    t.string   "seo_title"
    t.string   "seo_keywords"
    t.text     "seo_description"
    t.integer  "position"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.string   "one_ass_id"
    t.datetime "last_oneassed_at"
    t.boolean  "topper",           default: false
    t.integer  "discount_id"
    t.string   "special_image"
    t.boolean  "special_active",   default: false
  end

  add_index "categories", ["discount_id"], name: "index_categories_on_discount_id", using: :btree

  create_table "category_projects", force: true do |t|
    t.integer  "project_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_projects", ["category_id"], name: "index_category_projects_on_category_id", using: :btree
  add_index "category_projects", ["project_id"], name: "index_category_projects_on_project_id", using: :btree

  create_table "characteristic_names", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "one_ass_id"
  end

  create_table "characteristic_values", force: true do |t|
    t.string   "value"
    t.integer  "characteristic_name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "one_ass_id"
  end

  add_index "characteristic_values", ["characteristic_name_id"], name: "index_characteristic_values_on_characteristic_name_id", using: :btree

  create_table "characteristics_group_rows", force: true do |t|
    t.integer  "characteristics_group_id"
    t.integer  "characteristic_name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characteristics_group_rows", ["characteristic_name_id"], name: "index_characteristics_group_rows_on_characteristic_name_id", using: :btree
  add_index "characteristics_group_rows", ["characteristics_group_id"], name: "index_characteristics_group_rows_on_characteristics_group_id", using: :btree

  create_table "characteristics_group_vls", force: true do |t|
    t.integer  "characteristics_group_row_id"
    t.integer  "characteristic_value_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characteristics_group_vls", ["characteristic_value_id"], name: "index_characteristics_group_vls_on_characteristic_value_id", using: :btree
  add_index "characteristics_group_vls", ["characteristics_group_row_id"], name: "index_characteristics_group_vls_on_characteristics_group_row_id", using: :btree

  create_table "characteristics_groups", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "coupons", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "code"
    t.datetime "valid_till"
    t.boolean  "permanent",  default: false
    t.integer  "cart_id"
    t.datetime "used_at"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reusable",   default: false
  end

  add_index "coupons", ["cart_id"], name: "index_coupons_on_cart_id", using: :btree
  add_index "coupons", ["order_id"], name: "index_coupons_on_order_id", using: :btree
  add_index "coupons", ["user_id"], name: "index_coupons_on_user_id", using: :btree

  create_table "deal_products", force: true do |t|
    t.integer  "deal_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_products", ["deal_id"], name: "index_deal_products_on_deal_id", using: :btree
  add_index "deal_products", ["product_id"], name: "index_deal_products_on_product_id", using: :btree

  create_table "deals", force: true do |t|
    t.string   "title"
    t.boolean  "published",   default: false
    t.string   "image"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounts", force: true do |t|
    t.string   "title"
    t.integer  "amount"
    t.boolean  "all_products", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_page_banners", force: true do |t|
    t.string   "title"
    t.string   "title_red"
    t.string   "title_small"
    t.text     "description"
    t.string   "main_button_title"
    t.string   "main_button_url"
    t.boolean  "secondary_button_on",    default: false
    t.string   "secondary_button_title"
    t.string   "secondary_button_url"
    t.string   "image_big"
    t.string   "image_small"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",              default: false
  end

  create_table "images", force: true do |t|
    t.string   "image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "one_ass_path"
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree

  create_table "import_csv_lines", force: true do |t|
    t.string   "article"
    t.string   "title"
    t.string   "size"
    t.float    "price"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "import_id"
    t.string   "barcode"
  end

  add_index "import_csv_lines", ["import_id"], name: "index_import_csv_lines_on_import_id", using: :btree

  create_table "import_one_asses", force: true do |t|
    t.string   "offers"
    t.string   "import"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "import_xml", limit: 2147483647
    t.text     "offers_xml", limit: 2147483647
  end

  create_table "imports", force: true do |t|
    t.string   "file_xls"
    t.datetime "proccessed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "producer_id"
    t.integer  "stock_id"
  end

  add_index "imports", ["producer_id"], name: "index_imports_on_producer_id", using: :btree
  add_index "imports", ["stock_id"], name: "index_imports_on_stock_id", using: :btree

  create_table "line_item_characteristics", force: true do |t|
    t.integer  "characteristic_name_id"
    t.integer  "characteristic_value_id"
    t.integer  "line_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_item_characteristics", ["characteristic_name_id"], name: "index_line_item_characteristics_on_characteristic_name_id", using: :btree
  add_index "line_item_characteristics", ["characteristic_value_id"], name: "index_line_item_characteristics_on_characteristic_value_id", using: :btree
  add_index "line_item_characteristics", ["line_item_id"], name: "index_line_item_characteristics_on_line_item_id", using: :btree

  create_table "line_items", force: true do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",                   default: 1
    t.integer  "order_id"
    t.integer  "special_offer_id"
    t.string   "price_from_offer"
    t.string   "characteristics_from_offer"
    t.integer  "offer_limit"
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree
  add_index "line_items", ["special_offer_id"], name: "index_line_items_on_special_offer_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offer_characteristics", force: true do |t|
    t.integer  "product_offer_id"
    t.string   "title"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offer_characteristics", ["product_offer_id"], name: "index_offer_characteristics_on_product_offer_id", using: :btree

  create_table "offer_prices", force: true do |t|
    t.integer  "product_offer_id"
    t.string   "one_ass_price_type_id"
    t.float    "price"
    t.string   "currency"
    t.string   "unit"
    t.integer  "coefficient"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offer_prices", ["product_offer_id"], name: "index_offer_prices_on_product_offer_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "pay_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.float    "price_of_shipping", default: 0.0
    t.string   "kind_of_shipping"
    t.integer  "number",            default: 0
    t.integer  "city_code"
    t.string   "city_title"
    t.integer  "region_code"
    t.string   "region_title"
    t.string   "state"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "page_projects", force: true do |t|
    t.integer  "page_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_projects", ["page_id"], name: "index_page_projects_on_page_id", using: :btree
  add_index "page_projects", ["project_id"], name: "index_page_projects_on_project_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "permalink"
    t.string   "seo_title"
    t.string   "seo_keywords"
    t.text     "seo_description"
    t.text     "body"
    t.boolean  "published"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.boolean  "everywhereable",  default: false
  end

  create_table "parts", force: true do |t|
    t.string   "title"
    t.string   "code"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "order_id"
    t.string   "price"
    t.string   "state"
    t.text     "payload"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "avatar"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "job_title"
    t.string   "fb_url"
    t.string   "vk_url"
    t.string   "email"
    t.integer  "position"
    t.boolean  "published",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "producers", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "one_ass_id"
  end

  create_table "product_characteristics", force: true do |t|
    t.integer  "product_id"
    t.integer  "characteristic_name_id"
    t.integer  "characteristic_value_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_characteristics", ["characteristic_name_id"], name: "index_product_characteristics_on_characteristic_name_id", using: :btree
  add_index "product_characteristics", ["characteristic_value_id"], name: "index_product_characteristics_on_characteristic_value_id", using: :btree
  add_index "product_characteristics", ["product_id"], name: "index_product_characteristics_on_product_id", using: :btree

  create_table "product_offers", force: true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "one_ass_id"
    t.integer  "quantity",   default: 0
  end

  add_index "product_offers", ["product_id"], name: "index_product_offers_on_product_id", using: :btree

  create_table "products", force: true do |t|
    t.integer  "category_id"
    t.integer  "main_image_id"
    t.string   "title"
    t.text     "description"
    t.float    "price",                    default: 0.0
    t.boolean  "published",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "old_price"
    t.string   "article"
    t.boolean  "frontpageable",            default: false
    t.string   "seo_title"
    t.string   "seo_keywords"
    t.text     "seo_description"
    t.string   "one_ass_id"
    t.datetime "last_oneassed_at"
    t.integer  "import_id"
    t.integer  "producer_id"
    t.float    "producer_price"
    t.boolean  "benefit",                  default: false
    t.boolean  "hit",                      default: false
    t.boolean  "markdown",                 default: false
    t.boolean  "special_offer",            default: false
    t.string   "unit"
    t.integer  "characteristics_group_id"
    t.integer  "stock_id"
    t.string   "barcode"
    t.integer  "discount_id"
    t.string   "special_title"
    t.string   "special_slogan_red"
    t.text     "special_text"
    t.string   "special_button"
    t.string   "special_image"
    t.boolean  "special_active",           default: false
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["characteristics_group_id"], name: "index_products_on_characteristics_group_id", using: :btree
  add_index "products", ["discount_id"], name: "index_products_on_discount_id", using: :btree
  add_index "products", ["import_id"], name: "index_products_on_import_id", using: :btree
  add_index "products", ["main_image_id"], name: "index_products_on_main_image_id", using: :btree
  add_index "products", ["producer_id"], name: "index_products_on_producer_id", using: :btree
  add_index "products", ["stock_id"], name: "index_products_on_stock_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.string   "hostname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", force: true do |t|
    t.integer  "price_from"
    t.integer  "price_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "producer_id"
    t.integer  "category_id"
    t.string   "product_title"
  end

  add_index "searches", ["category_id"], name: "index_searches_on_category_id", using: :btree
  add_index "searches", ["producer_id"], name: "index_searches_on_producer_id", using: :btree

  create_table "special_offers", force: true do |t|
    t.integer  "product_one_id"
    t.integer  "product_two_id"
    t.float    "special_price"
    t.boolean  "published",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "special_offers", ["product_one_id"], name: "index_special_offers_on_product_one_id", using: :btree
  add_index "special_offers", ["product_two_id"], name: "index_special_offers_on_product_two_id", using: :btree

  create_table "stocks", force: true do |t|
    t.string   "title"
    t.string   "phone"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "through_product_characteristics", force: true do |t|
    t.integer  "product_id"
    t.integer  "characteristic_name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "through_product_characteristics", ["characteristic_name_id"], name: "index_through_product_characteristics_on_characteristic_name_id", using: :btree
  add_index "through_product_characteristics", ["product_id"], name: "index_through_product_characteristics_on_product_id", using: :btree

  create_table "tizers", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.string   "phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
