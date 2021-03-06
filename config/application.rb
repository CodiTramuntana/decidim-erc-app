# frozen_string_literal: true

require_relative "boot"

require "rails/all"

require "net/http"
require "openssl"
require "resolv-replace"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimErcApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # initializer 'add named route overrides' do |app|
    #   app.routes_reloader.paths << File.expand_path('../named_routes_overrides.rb',__FILE__)
    #   # this seems to cause these extra routes to be loaded last, so they will define named routes last.
    # end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Make decorators available
    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    # Update Decidim registries after initialization.
    config.after_initialize do
      # Adding custom content to the bottom of the user profile sidebar.
      Decidim.view_hooks.register(:user_profile_bottom, priority: Decidim::ViewHooks::HIGH_PRIORITY) do |view_context|
        view_context = view_context.controller.view_context
        view_context.render(partial: "decidim/user_scope")
      end
      # Stop showing proposals in the participatory process show page.
      Decidim.view_hooks.send(:hooks).delete_if { |k, _| k == :participatory_space_highlighted_elements }
      # Stop being able to find user in global search bar.
      Decidim.find_resource_manifest(:user).searchable = false
      # Remove user interests from user menu.
      Decidim::MenuRegistry.destroy(:user_menu)
      Decidim.menu(:user_menu) do |menu|
        menu.item t("account", scope: "layouts.decidim.user_profile"),
                  decidim.account_path,
                  position: 1.0,
                  active: :exact

        menu.item t("notifications_settings", scope: "layouts.decidim.user_profile"),
                  decidim.notifications_settings_path,
                  position: 1.1

        if available_verification_workflows.any?
          menu.item t("authorizations", scope: "layouts.decidim.user_profile"),
                    decidim_verifications.authorizations_path,
                    position: 1.2
        end

        if current_organization.user_groups_enabled? && user_groups.any?
          menu.item t("user_groups", scope: "layouts.decidim.user_profile"),
                    decidim.own_user_groups_path,
                    position: 1.3
        end

        menu.item t("my_data", scope: "layouts.decidim.user_profile"),
                  decidim.data_portability_path,
                  position: 1.5

        menu.item t("delete_my_account", scope: "layouts.decidim.user_profile"),
                  decidim.delete_account_path,
                  position: 999,
                  active: :exact
      end
    end
  end
end
