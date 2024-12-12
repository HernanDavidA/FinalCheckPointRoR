class Archive < ApplicationRecord
  has_many_attached :images

  validates :title, presence: true, length: { maximum: 25, minimum: 5 }
  validates :description, presence: true, length: { maximum: 500, minimum: 10 }
end
