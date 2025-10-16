class Pokemon < ApplicationRecord
  has_many :pokeballs, dependent: :destroy
  has_many :trainers, through: :pokeballs
  has_one_attached :photo
end
