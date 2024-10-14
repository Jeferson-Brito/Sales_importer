class Sale < ApplicationRecord
  validates :purchaser_name, presence: true
  validates :item_description, presence: true
  validates :item_price, presence: true
  validates :purchase_count, presence: true
  validates :merchant_address, presence: true
  validates :merchant_name, presence: true
end
