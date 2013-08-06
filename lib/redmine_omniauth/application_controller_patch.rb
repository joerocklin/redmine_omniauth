# This file handles patching the login process. We override the require_login
# method from the ApplicationController to go to one of the omniauth methods.
require_dependency 'application_controller'

module Redmine::OmniAuth
  module ApplicationControllerPatch
    def self.included(base)
      base.class_eval do
        unloadable

        alias_method_chain :require_login, :omniauth
      end
    end

    def require_login_with_omniauth
      if !User.current.logged?
        # Extract only the basic url parameters on non-GET requests
        if request.get?
          url = url_for(params)
        else
          url = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id], :project_id => params[:project_id])
        end
        respond_to do |format|
          format.html { redirect_to "/auth/connector", :back_url => url }
          format.atom { redirect_to "/auth/connector", :back_url => url }
          format.xml  { head :unauthorized, 'WWW-Authenticate' => 'Basic realm="Redmine API"' }
          format.js   { head :unauthorized, 'WWW-Authenticate' => 'Basic realm="Redmine API"' }
          format.json { head :unauthorized, 'WWW-Authenticate' => 'Basic realm="Redmine API"' }
        end
        return false
      end
      true
    end
  end
end

ApplicationController.send(:include, Redmine::OmniAuth::ApplicationControllerPatch)
