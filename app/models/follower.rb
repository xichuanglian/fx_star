class Follower < User
  has_many :followships

  mount_uploader :avatar, AvatarUploader
end
