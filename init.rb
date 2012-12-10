# Patches to existing classes/modules
ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_omniauth/account_controller_patch'
  require_dependency 'redmine_omniauth/application_controller_patch'
end

Redmine::Plugin.register :redmine_omniauth do
  name 'Redmine Omniauth plugin'
  author 'Joe Rocklin'
  description 'Allow authentication via omniauth connectors'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://github.com/joerocklin'
end

# Tell rails to use the omniauth middleware
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end
