# frozen_string_literal: true

unless Rails.env.test?
  filepath = Rails.root.join("config", "civi_crm", "local_comarcal_relationships.yml")
  raise "Run `bundle exec rake civi_crm:init`" unless File.exist?(filepath)

  Decidim::Erc::CrmAuthenticable::SCOPE_CODES = YAML.load_file(filepath)
end
