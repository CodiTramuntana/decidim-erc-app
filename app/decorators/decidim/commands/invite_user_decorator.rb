# frozen_string_literal: true

# This decorator set scope by default to new admins.
Decidim::InviteUser.class_eval do
  private

  def invite_user
    @user = Decidim::User.new(
      name: form.name,
      email: form.email.downcase,
      nickname: Decidim::UserBaseEntity.nicknamize(form.name, organization: form.organization),
      organization: form.organization,
      admin: form.role == "admin",
      roles: form.role == "admin" ? [] : [form.role].compact,
      scope: Decidim::Scope.find_by(code: "1")
    )
    @user.invite!(
      form.invited_by,
      invitation_instructions: form.invitation_instructions
    )
  end
end
