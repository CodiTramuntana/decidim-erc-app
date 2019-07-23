# frozen_string_literal: true

# This decorator handles the easy acces of some pieces of information stored
# in the `extended_data` Hash, that are unique to the ERC app.
Decidim::User.class_eval do
  # Method added.
  # Syntactic sugar to access the scope assigned in the registration process of Decidim::Erc::CrmLogin.
  def scope
    @scope ||= organization.scopes.find_by(id: extended_data["member_of"])
  end

  # Method added.
  # Syntactic sugar to access the phone number assigned in the registration process of Decidim::Erc::CrmLogin.
  def phone_number
    extended_data["phone"]
  end
end
