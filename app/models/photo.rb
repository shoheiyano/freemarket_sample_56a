class Photo < ApplicationRecord
  belongs_to :item

  mount_uploader :url, UrlUploader
end
