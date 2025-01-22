# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim.git", branch: "release/0.29-stable" }.freeze
# TERM_CUSTOMIZER_VERSION = { git: "https://github.com/mainio/decidim-module-term_customizer", branch: "main" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-cdtb", git: "https://github.com/CodiTramuntana/decidim-module-cdtb.git", branch: "main"
gem "decidim-erc-crm_authenticable", git: "https://github.com/CodiTramuntana/decidim-erc-crm_authenticable.git", branch: "update/0.29-stable"
# gem "decidim-term_customizer", TERM_CUSTOMIZER_VERSION

gem "daemons"
gem "deface"
gem "delayed_job_active_record"
gem "openssl"
gem "puma"
gem "whenever", require: false

# TODO: move to rubyXL for amendments export
gem "spreadsheet"
gem "wkhtmltopdf-binary"

# TODO: Psych problem: https://github.com/laserlemon/figaro/issues/289
# gem "figaro"
# This gem is an alternative to Figaro meanwhile fix that problem in Figaro.
# https://github.com/hlascelles/figjam
gem "figjam"

gem "differ"

# concurrent-ruby v1.3.5 has removed the dependency on logger
gem "concurrent-ruby", "~> 1.3.4"

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "bootsnap"
  gem "byebug", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "web-console"
end
