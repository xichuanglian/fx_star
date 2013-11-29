module ControllerModules
  module CreateUserModule
    private

    def hide_password h
      h[:password] = Digest::MD5.hexdigest h[:password]
      return h
    end

    def verify_user_name user_name
      unless Trader.user_name_format.match user_name
        flash[:field_error] ||= Hash.new
        flash[:field_error][:user_name] = "Invalid user name!"
      end
    end

    def verify_unique_user_name user_name
      unless not Trader.where(name: user_name).exists?
        flash[:field_error] ||= Hash.new
        flash[:field_error][:user_name] = "User name occupied!"
      end
    end

    def verify_password password, password_confirmation
      unless password == password_confirmation
        flash[:field_error] ||= Hash.new
        flash[:field_error][:password] = "Passwords do not match!"
      end
    end

    def verify_email email
      unless Trader.email_format.match email
        flash[:field_error] ||= Hash.new
        flash[:field_error][:email] = "Invalid email!"
      end
    end
  end
end
