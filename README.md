# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# DB設計

## usersテーブル

|Column|Type|Options|
|------|----|-------|
|first_name|string|null: false|
|last_name|string|null: false|
|first_name_kana|string|null: false|
|last_name_kana|string|null: false|
|nickname|string|null: false|
|email|string|null: false|
|password|string|null: false|
|password_confirmation|string|null: false|
|birthday|date|null: false|
|provider|string|
|uid|string|

### Association
- has_many :items
- has_one :address
- has_one :profile


## profilesテーブル

|Column|Type|Options|
|------|----|-------|
|image|string|
|introduction_essay|text|
|user_id|references|null: false, foreign_key: true|

### Association
- belongs_to :user


## addressesテーブル

|Column|Type|Options|
|------|----|-------|
|postal_cord|integer|null: false|
|prefecture|string|null: false|
|city|string|null: false|
|block|string|null: false|
|building|string|
|phone_number|integer|
|user_id|references|null: false, foreign_key: true|

### Association
- belongs_to :user


## creditsテーブル

|Column|Type|Options|
|------|----|-------|
|card_number|integer|null: false|
|expiration_month|integer|null: false|
|expiration_year|integer|null: false|
|security_cord|integer|null: false|
|user_id|references|null: false, foreign_key: true|

### Association
- belongs_to :user


## itemsテーブル

|Column|Type|Options|
|------|----|-------|
|trade_name|string|null: false|
|description|text|null: false|
|condition|string|null: false|
|postage|string|null: false|
|delivery_method|string|null: false|
|shipment_area|string|null: false|
|shipment_date|string|null: false|
|price|integer|null: false|
|seller_id|references|null: false, foreign_key: true|
|buyer_id|references|
|user_id|references|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :category
- belongs_to :size
- belongs_to :brand
- has_many :photos
- has_many :likes
- has_one :order


## categoriesテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|

### Association
- has_many :items
- has_ancestry


## sizesテーブル

|Column|Type|Options|
|------|----|-------|
|size|string|null: false|

### Association
- has_many :items


## brandsテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|

### Association
- has_many :items


## photosテーブル

|Column|Type|Options|
|------|----|-------|
|url|string|null: false|
|item_id|references|null: false, foreign_key: true|

### Association
- has_many :items


## trading_partnersテーブル

|Column|Type|Options|
|------|----|-------|
|seller_id|null: false, foreign_key:{to_table::users}|
|buyer_id|null: false, foreign_key:{to_table::users}|

### Association
- belongs_to :seller_id, class_name:"User"
- belongs_to :buyer_id, class_name:"User"
- has_one :order


## ordersテーブル

|Column|Type|Options|
|------|----|-------|
|status|string|null: false|
|item_id|references|null: false, foreign_key: true|
|trading_partner_id|references|null: false, foreign_key: true|

### Association
- belongs_to :item
- belongs_to :trading_partner


## likesテーブル

|Column|Type|Options|
|------|----|-------|
|item_id|references|null: false, foreign_key: true|
|user_id|references|null: false, foreign_key: true|

### Association
- belongs_to :item
- belongs_to :user