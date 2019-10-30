# frozen_string_literal: true

# https://github.com/CodiTramuntana/decidim-erc-crm_authenticable/blob/master/lib/decidim/erc/crm_authenticable.rb
Decidim::Erc::CrmAuthenticable::CIVICRM_COMARCAL_EXCEPTIONS = %w(
  4
  5723
  5724
  5727
  5729
).freeze
filepath = Rails.root.join("config", "civi_crm", "decidim_scopes_mapping.yml")
Decidim::Erc::CrmAuthenticable::SCOPE_CODES = YAML.load_file(filepath).freeze if File.exist?(filepath)
Decidim::Erc::CrmAuthenticable::VALID_MBSP_STATUS_IDS = %w(1 2).freeze
Decidim::Erc::CrmAuthenticable::VALID_MBSP_JOIN_DATE = Date.parse("21-12-2019").freeze
