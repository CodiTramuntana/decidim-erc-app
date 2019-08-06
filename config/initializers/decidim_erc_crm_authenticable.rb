# frozen_string_literal: true

unless Rails.env.test?
  filepath = Rails.root.join("config", "civi_crm", "local_comarcal_relationships.yml")
  Decidim::Erc::CrmAuthenticable::SCOPE_CODES = YAML.load_file(filepath) if File.exist?(filepath)
end
