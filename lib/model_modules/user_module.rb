module ModelModules
  module UserModule
    def self.included(receiver)
      receiver.class_eval do
        field :user_name, type: String
        field :password, type: String
        field :email, type: String
        field :created_time, type: DateTime
        embeds_one :account, as: :accountable

        validates_format_of :user_name, with: /\A[A-Za-z]\w{2,31}\Z/
        validates_uniqueness_of :user_name
        validates_confirmation_of :password
        validates_format_of :email, with: /\A[\w.]+@\w+(.\w+)+\Z/
      end
    end
  end
end
