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

ActiveRecord::Schema.define(version: 20170111131355) do

  create_table "admins", force: true do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", force: true do |t|
    t.string   "popshops_index"
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cart_offers", force: true do |t|
    t.integer  "cart_id"
    t.integer  "offer_id"
    t.integer  "registry_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cart_products", force: true do |t|
    t.integer  "cart_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "registry_id"
  end

  create_table "carts", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_types", force: true do |t|
    t.string   "popshops_index"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchants", force: true do |t|
    t.integer  "merchant_type_id"
    t.string   "popshops_index"
    t.string   "name"
    t.string   "network"
    t.integer  "product_count"
    t.integer  "deal_count"
    t.string   "network_merchant_id"
    t.string   "country"
    t.string   "category"
    t.string   "popshops_merchant_type"
    t.text     "logo_url"
    t.text     "url"
    t.text     "site_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", force: true do |t|
    t.integer  "merchant_id"
    t.integer  "product_id"
    t.string   "popshops_index"
    t.string   "sku"
    t.string   "popshops_merchant"
    t.string   "name"
    t.text     "description"
    t.text     "url"
    t.text     "image_url_large"
    t.string   "currency_iso"
    t.decimal  "price_merchant"
    t.decimal  "price_retail"
    t.decimal  "estimated_price_total"
    t.string   "condition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_methods", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "custom_name"
  end

  create_table "product_registries", force: true do |t|
    t.integer "product_id"
    t.integer "registry_id"
    t.integer "quantity"
    t.integer "purchased",   default: 0
  end

  create_table "products", force: true do |t|
    t.integer  "brand_id"
    t.integer  "merchant_id"
    t.string   "popshops_index"
    t.string   "category"
    t.string   "name"
    t.text     "description"
    t.string   "popshops_brand"
    t.decimal  "price_min"
    t.decimal  "price_max"
    t.integer  "offer_count"
    t.text     "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registries", force: true do |t|
    t.boolean "active",            default: true
    t.text    "name"
    t.integer "payment_method_id"
    t.decimal "goal"
    t.boolean "private"
  end

  create_table "user_registries", force: true do |t|
    t.integer  "user_id"
    t.integer  "registry_id"
    t.string   "association_type"
    t.string   "preference"
    t.text     "account"
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
    t.integer  "owner_id"
    t.string   "preferred_payment"
    t.string   "paypal_acct"
    t.string   "venmo_acct"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
