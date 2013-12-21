class User
  include Mongoid::Document

  field :user_name, type: String
  field :password, type: String
  field :email, type: String
  field :created_time, type: DateTime
  embeds_one :account, as: :accountable

  def self.user_name_format
    /\A[A-Za-z]\w{2,31}\Z/
  end

  def self.email_format
    /\A[\w.]+@\w+(\.\w+)+\Z/
  end

  #validates_format_of :user_name, with: self.user_name_format
  #validates_uniqueness_of :user_name
  #validates_confirmation_of :password
  #validates_format_of :email, with: self.email_format
end
