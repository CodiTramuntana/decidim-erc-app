# frozen_string_literal: true
# This migration comes from decidim (originally 20181211080834)

class AddScopeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :decidim_scope_id, :integer
  end
end
