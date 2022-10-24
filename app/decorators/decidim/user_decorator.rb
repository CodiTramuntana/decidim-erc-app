# frozen_string_literal: true

Decidim::User.class_eval do
  belongs_to :scope, foreign_key: :decidim_scope_id
end
