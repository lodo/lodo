require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Lodo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :nb

    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, :fixture => true
    # end

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.time_zone = 'UTC'
    
    # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
    # All files from config/locales/*.rb,yml are added automatically.
    # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :nb
    
    # Your secret key for verifying cookie session data integrity.
    # If you change this key, all old sessions will become invalid!
    # Make sure the secret is at least 30 characters and all random, 
    # no regular words or you'll be exposed to dictionary attacks.
    config.action_dispatch.session = {
      :session_key => '_lodo3_session',
      :secret      => '29e52c8e64c464b41e52b98c9cceb4e43d1d8870df42124cd96be3c4004179720c0326431b0126f1f27d9c65bd834d1028c8f745ddcc8484e32ff0ac3e7d75fa'
    }
    
    # define js asset loading order (:all adds :defaults in front)
    config.action_view.javascript_expansions = { :defaults => ['jquery', 'rails'] }
  end
end



ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "mail.freecodeint.com",
  :port => 25,
  #    :domain => "freecode.no",
  #    :user_name => "axel.liljencrantz@freecode.no",
  #    :password => "MyPassword",
  :authentication => :plain
}
