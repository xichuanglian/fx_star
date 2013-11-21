class Followship
  include Mongoid::Document

  field :percentage, type: Integer
  field :since, type: DateTime

  belongs_to :follower
  belongs_to :trader
end
