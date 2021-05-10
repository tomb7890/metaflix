class Movie < ApplicationRecord
  scope :metascore_sixty_or_higher, -> () { where("metascore > 60") }
  validates :title, presence: true
end
