# Handle the omniauth callbacks to perform the user login
require_dependency 'account_controller'

module Redmine::OmniAuth
  module AccountControllerPatch
    def login_with_omniauth
      auth = request.env["omniauth.auth"]
      uid ||= auth['uid']
      email ||= auth['info']['email']

      user = User.find_by_login(uid) || User.find_by_mail(email)

      # TODO Refactor to include account creation
      if user.blank? || user.is_a?(AnonymousUser)
        invalid_credentials
        error = l :notice_account_unknown_user

        if email
          error += " - " + email
        end

        if auth['extra']['error']
          error += " (" + auth['extra']['error'] + ")"
        end

        flash[:error] = error
        redirect_to signin_url
      else
        successful_authentication(user)
      end
    end
  end
end

AccountController.send(:include, Redmine::OmniAuth::AccountControllerPatch)
