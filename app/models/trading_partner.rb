class TradingPartner < ApplicationRecord
  belongs_to :seller_id, class_name: "User"
  belongs_to :buyer_id, class_name: "User"
  has_one :order
end
