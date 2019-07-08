# frozen_string_literal: true

Decidim::User.class_eval do
  # Syntactic sugar to access the scope assigned in the registration process of Decidim::Erc::CrmLogin.
  def scope
    @scope ||= organization.scopes.find_by(id: extended_data["member_of"])
  end

  # Syntactic sugar to access the phone number assigned in the registration process of Decidim::Erc::CrmLogin.
  def phone_number
    extended_data["phone"]
  end
end
