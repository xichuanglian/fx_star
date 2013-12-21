class Account
  include Mongoid::Document

  field :account_number, type: String
  field :password, type: String
  field :balance, type: Float
  field :real, type: Boolean


  embedded_in :accountable, polymorphic: true
  has_many :trade_records
  has_many :account_status_records
end
