# frozen_string_literal: true

# https://github.com/CodiTramuntana/decidim-erc-crm_authenticable/blob/master/lib/decidim/erc/crm_authenticable.rb
Decidim::Erc::CrmAuthenticable::CIVICRM_COMARCAL_EXCEPTIONS = %w(
  9300
  2100
  5600
  9200
  9900
).freeze
filepath = Rails.root.join("config", "civi_crm", "decidim_scopes_mapping.yml")
Decidim::Erc::CrmAuthenticable::SCOPE_CODES = YAML.load_file(filepath).freeze if File.exist?(filepath)
Decidim::Erc::CrmAuthenticable::VALID_MBSP_NAMES = %w(Militant).freeze
Decidim::Erc::CrmAuthenticable::VALID_MBSP_STATUS_IDS = %w(1 2).freeze
Decidim::Erc::CrmAuthenticable::VALID_MBSP_JOIN_DATE = Date.parse("11-08-2019").freeze
