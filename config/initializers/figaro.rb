# frozen_string_literal: true

env = Rails.env
keys = %w()
unless env.development? || env.test?
  keys += %w(DB_DATABASE DB_PASSWORD DB_USERNAME)
  keys += %w(MAILER_SMTP_ADDRESS MAILER_SMTP_DOMAIN MAILER_SMTP_PORT MAILER_SMTP_USER_NAME MAILER_SMTP_PASSWORD)
  # keys += %w(GEOCODER_LOOKUP_APP_ID GEOCODER_LOOKUP_APP_CODE)
  keys += %w(CIVICRM_API_BASE CIVICRM_SITE_KEY CIVICRM_API_KEY ERC_SECRET_KEY)
  keys += %w(CSV_USERS_PRE_PATH)
end
Figaro.require_keys(keys)
