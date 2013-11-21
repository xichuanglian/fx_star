class Account
  include Mongoid::Document

  field :account_number, type: String
  field :password, type: String
  field :balance, type: Float
  field :real, type: Boolean

  embeded_in :accountable, polymorphic: true
  has_many :trade_records
end
