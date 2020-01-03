module ApplicationHelper
  def price_jpy(price)
    "¥#{price.to_s(:delimited, delimiter: ',')}"
  end
end
