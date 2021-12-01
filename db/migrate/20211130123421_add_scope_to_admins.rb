class AddScopeToAdmins < ActiveRecord::Migration[5.2]
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
