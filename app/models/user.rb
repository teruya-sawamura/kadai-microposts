class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  #userとmicropostの一対多関係
  has_many :microposts
  
  #userとrelationshipの一対多関係（フォロー・フォロワー）
  #フォロー側
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  #フォロワー側
  has_many :reverses_of_relationship, class_name: "Relationship", foreign_key: "follow_id"
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  
  #userとfavoriteの一対多関係（お気に入り機能）
  #ユーザ側
  has_many :favorites
  has_many :likes, through: :favorites, source: :micropost
  
  
  #フォロー関係アクション
  
  #フォローする
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  #フォロー外す
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  #フォローしているかどうか
  def following?(other_user)
    self.followings.include?(other_user)
  end
  #タイムライン取得
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  
  #お気に入り関係アクション
  
  #お気に入りする
  def like(micropost)
      favorites.find_or_create_by(micropost_id: micropost.id)
  end
  #お気に入り解除
  def unlike(micropost)
      favorite = favorites.find_by(micropost_id: micropost.id)
      favorite.destroy if favorite
  end
  #お気に入りしているかどうか
  def like_now?(micropost)
      likes.include?(micropost)
  end
  
end