# frozen_string_literal: true

if Rails.env.development?
  filepath = Rails.root.join("config", "civi_crm", "decidim_scopes_mapping.yml")
  Decidim::Erc::CrmAuthenticable::SCOPE_CODES = YAML.load_file(filepath).freeze
  Decidim::Erc::CrmAuthenticable::VALID_MBSP_STATUS_IDS = %w(1 2).freeze
  Decidim::Erc::CrmAuthenticable::VALID_MBSP_JOIN_DATE = 3.months.ago.freeze
end
