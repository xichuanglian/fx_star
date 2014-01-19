# -*- coding: utf-8 -*-
module ControllerModules
  module CreateUserModule
    private

    def hide_password h
      h[:password] = Digest::MD5.hexdigest h[:password]
      return h
    end

    def verify_user_name user_name
      unless User.user_name_format.match user_name
        flash[:field_error] ||= Hash.new
        flash[:field_error][:user_name] = "用户名格式错误"
      end
    end

    def verify_unique_user_name user_name, user_type
      unless not user_type.where(name: user_name).exists?
        flash[:field_error] ||= Hash.new
        flash[:field_error][:user_name] = "该用户名已经被注册了"
      end
    end

    def verify_password password, password_confirmation
      unless password == password_confirmation
        flash[:field_error] ||= Hash.new
        flash[:field_error][:password] = "两次输入的密码不同"
      end
      unless password.length > 0
        flash[:field_error] ||= Hash.new
        flash[:field_error][:password] = "密码不能为空"
      end
    end

    def verify_email email
      unless User.email_format.match email
        flash[:field_error] ||= Hash.new
        flash[:field_error][:email] = "邮箱地址格式错误"
      end
    end
  end
end
