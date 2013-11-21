class TradeRecord
  include Mongoid::Document

  field :currency, type: Symbol
  field :price, type: Float
  field :amount, type: Integer
  field :operation, type: Symbol
  field :timestamp, type: DateTime

  belongs_to :account
end
