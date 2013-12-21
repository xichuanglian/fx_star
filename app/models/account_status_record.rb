class AccountStatusRecord
  include Mongoid::Document

  field :equity, type: Float
  field :profit, type: Float

  belongs_to :account
end