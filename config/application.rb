# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require 'net/http'
require 'openssl'
require 'resolv-replace'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimCleanApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Default app time zone
    # config.time_zone = 'Madrid'

    # initializer 'add named route overrides' do |app|
    #   app.routes_reloader.paths << File.expand_path('../named_routes_overrides.rb',__FILE__)
    #   # this seems to cause these extra routes to be loaded last, so they will define named routes last.
    # end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Make decorators available
    config.to_prepare do
      Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
        require_dependency(c)
      end
    end
  end
end
