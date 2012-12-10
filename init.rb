# Patches to existing classes/modules
ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_omniauth/account_controller_patch'
  require_dependency 'redmine_omniauth/application_controller_patch'
end

Redmine::Plugin.register :redmine_omniauth do
  name 'Redmine Omniauth plugin'
  author 'Joe Rocklin'
  description 'Allow authentication via omniauth connectors'
  version '0.1.0'
  url 'http://example.com/path/to/plugin'
  author_url 'http://github.com/joerocklin'
end

# Tell rails to use the omniauth middleware
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :plm, ENV['PLM_AUTH_ID'], ENV['PLM_AUTH_SECRET']
end

# Change the menu options to remove login/logout/register links and replace the
# login link with one of our own (in case it's needed)
Redmine::MenuManager.map :account_menu do |menu|
  menu.delete :login
  menu.delete :logout
  menu.delete :register

  menu.push :login, '/auth/plm', { :first => true, :if => Proc.new { !User.current.logged? } }
end
