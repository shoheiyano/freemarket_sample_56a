class Photo < ApplicationRecord
  belongs_to :item
  mount_uploader :url, ImageUploader #  mount_uploaderとImageUploaderというものは固定です。imageカラムではなくurlカラム、だからと言って変更してはいけないそうです。
end
