# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

# We are pointing to master, because some new features are required.
DECIDIM_VERSION = "0.19.0"
# We are pointing to apply_register_to_civi_crm until the PR gets merged.
DECIDIM_ERC_CRM_AUTHENTICABLE_VERSION = {
  git: "https://github.com/CodiTramuntana/decidim-erc-crm_authenticable.git"
}

gem 'decidim', DECIDIM_VERSION
gem 'decidim-erc-crm_authenticable', DECIDIM_ERC_CRM_AUTHENTICABLE_VERSION

gem 'daemons'
gem 'delayed_job_active_record'
gem 'puma', '~> 3.0'
gem 'uglifier', '>= 1.3.0'
gem 'whenever'

gem 'figaro', '>= 1.1.1'
gem 'openssl'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug', platform: :mri
  gem "bootsnap"
end

group :development do
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'faker', '~> 1.8.4'
  gem 'letter_opener_web', '~> 1.3.0'
  gem 'listen', '~> 3.1.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end
