# frozen_string_literal: true

env = Rails.env
keys = %w[SECRET_KEY_BASE]
unless env.development? || env.test?
  keys += %w[DB_DATABASE DB_PASSWORD DB_USERNAME]
  keys += %w[CIVICRM_API_BASE CIVICRM_SITE_KEY CIVICRM_API_KEY ERC_SECRET_KEY]
end
Figaro.require_keys(keys)
