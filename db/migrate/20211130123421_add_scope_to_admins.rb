class AddScopeToAdmins < ActiveRecord::Migration[5.2]
  class Decidim::User < Decidim::UserBaseEntity
    self.table_name = :decidim_users
    belongs_to :scope, foreign_key: :decidim_scope_id
  end

  def change
    admins = Decidim::User.where(admin: true)

    if admins.present?
      organization = Decidim::Organization.first

      scope = Decidim::Scope.find_or_create_by!(
        decidim_organization_id: organization.id,
        name: { "ca": "Organització", "en": "Organization", "es": "Organization" },
        code: "1"
      )

      admins.find_each do |admin|
        unless admin.scope.present?
          admin.scope = scope
          admin.save!(validate: false)
        end
      end
    end
  end
end
