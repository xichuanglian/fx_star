require 'model_modules/user_module'

class Trader
  include Mongoid::Document
  include ModelModules::UserModule
  has_many :followships
end
