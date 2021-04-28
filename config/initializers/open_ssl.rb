# frozen_string_literal: true

require 'net/smtp'
ctx= Net::SMTP.default_ssl_context
ctx.min_version= OpenSSL::SSL::TLS1_2_VERSION 
ctx.max_version= nil
