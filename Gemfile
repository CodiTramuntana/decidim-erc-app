# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

# We are pointing to master, because some new features are required.
DECIDIM_VERSION = {git: "https://github.com/decidim/decidim.git"}

gem 'daemons'
gem 'delayed_job_active_record'
gem 'puma', '~> 3.0'
gem 'uglifier', '>= 1.3.0'
gem 'whenever'

gem 'figaro', '>= 1.1.1'
gem 'openssl'

gem 'decidim', DECIDIM_VERSION
# For integration environment use:
gem 'decidim-erc-crm_authenticable', git: "https://github.com/CodiTramuntana/decidim-erc-crm_authenticable.git", branch: 'apply_register_to_civi_crm'
# For local development use:
# gem 'decidim-erc-crm_authenticable', path: '../decidim-erc-crm_authenticable'

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
