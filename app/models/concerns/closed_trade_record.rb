class ClosedTradeRecord
  include Mongoid::Document

  field :trade_id, type: Symbol
  field :fx_account, type: Symbol
  field :amount, type: Integer
  field :operation, type: Symbol
  field :gross_pl, type: Float
  field :commission, type: Float
  field :open_rate, type: Float
  field :open_quoted_id, type: Symbol
  field :open_time, type: DateTime
  field :close_rate, type: Float
  field :close_time, type: DateTime
  field :value_date, type: Symbol

  belongs_to :account
end
