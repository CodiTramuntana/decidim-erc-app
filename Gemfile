# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "rails", "< 6"
DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim.git", branch: "release/0.24-stable" }.freeze
TERM_CUSTOMIZER_VERSION = { git: "https://github.com/mainio/decidim-module-term_customizer", branch: "0.24-stable" }.freeze
DECIDIM_ERC_CRM_AUTHENTICABLE_VERSION = {path: "/home/oliver/prog/decidim/modules/decidim-erc-crm_authenticable"}
# {
#   git: "https://github.com/CodiTramuntana/decidim-erc-crm_authenticable.git", tag: "v1.1.6"
# }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-erc-crm_authenticable", DECIDIM_ERC_CRM_AUTHENTICABLE_VERSION
gem "decidim-term_customizer", TERM_CUSTOMIZER_VERSION

gem "daemons"
gem "deface"
gem "delayed_job_active_record"
gem "puma", ">= 4.3"
gem "uglifier", ">= 1.3.0"
gem "whenever"

gem "figaro", ">= 1.1.1"
gem "openssl"

gem "differ"

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "bootsnap"
  gem "byebug", platform: :mri
end

group :development do
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
  gem "letter_opener_web", "~> 1.3.0"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end
