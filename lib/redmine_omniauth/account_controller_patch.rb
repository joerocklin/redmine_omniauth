require_dependency 'account_controller'

require 'pp'

module Redmine::OmniAuth
  module AccountControllerPatch
    def login_with_omniauth
      auth = request.env["omniauth.auth"]
      uid = auth['extra']['raw_info']['login']

      user = User.find_by_login(uid) || User.find_by_mail(uid)

      # TODO Refactor to include account creation
      if user.blank?
        invalid_credentials
        error = l :notice_account_invalid_credentials

        flash[:error] = error
        redirect_to signin_url
      else
        successful_authentication(user)
      end
    end
  end
end

AccountController.send(:include, Redmine::OmniAuth::AccountControllerPatch)
