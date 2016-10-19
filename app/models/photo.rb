class Photo < ActiveRecord::Base
  dragonfly_accessor :image

  has_one :post
  validates :image, presence: true
  validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false, message: "Should be either jpg, png or bmp"
end
