# frozen_string_literal: true

# This decorator set scope by default to new admins.
module Decidim::Commands::InviteUserDecorator
  def self.decorate
    Decidim::InviteUser.class_eval do
      private

      def invite_user
        @user = Decidim::User.new(
          name: form.name,
          email: form.email.downcase,
          nickname:,
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

      def nickname
        Decidim::UserBaseEntity.nicknamize(form.name, organization: current_organization)
        initials = form.name.split.map { |w| w.chars.first }.join
        Decidim::UserBaseEntity.nicknamize(initials, organization: current_organization).upcase
      end
    end
  end
end

::Decidim::Commands::InviteUserDecorator.decorate
