class Micropost < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: {maximum:255}
  
  #favoriteとmicropostの一対多関係
  #投稿側
  has_many :reverses_of_favorites, class_name: "Favorite", foreign_key: "micropost_id"
  has_many :users, through: :reverses_of_favorites
end
