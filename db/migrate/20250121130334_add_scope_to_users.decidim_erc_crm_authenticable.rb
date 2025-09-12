# frozen_string_literal: true

# This migration comes from decidim_erc_crm_authenticable (originally 20190725110927)
class AddScopeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :decidim_scope_id, :integer
  end
end
