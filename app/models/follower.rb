class Follower < User
  has_many :followships

  field :trade_account_name, type: String
  field :trade_account_email, type: String
  field :trade_account_password, type: String
  field :trade_account_identity_number, type: String

  mount_uploader :idcard, IdcardUploader
end
