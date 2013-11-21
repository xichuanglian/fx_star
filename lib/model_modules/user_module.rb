module ModelModules
  module UserModule
    def self.included(receiver)
      receiver.class_eval do
        field :user_name, type: String
        field :password, type: String
        field :email, type: String
        field :created_time, type: DateTime
        embeds_one :account, as: :accountable
      end
    end
  end
end