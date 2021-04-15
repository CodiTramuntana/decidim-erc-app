# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = 'Decidim ERC APP'

  config.mailer_sender = 'decidim@decideix.com'

  # Change these lines to set your preferred locales
  config.default_locale = :ca
  config.available_locales = [:ca]

  # Configure available options for Decidim::Amendment::VisibilityStepSetting::options
  config.amendments_visibility_options = %w(all participants scope)


  config.enable_html_header_snippets = true
  config.track_newsletter_links = true
  # config.geocoder = {
  #   static_map_url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview",
  #   here_api_key: Rails.application.secrets.geocoder[:here_api_key]
  # }
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
