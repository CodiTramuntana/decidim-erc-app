# frozen_string_literal: true

# This decorator adds the logic to remove user from admin panel in participants.
Decidim::DestroyAccount.class_eval do
  # Method override.
  # Add current_user.
  def initialize(user, form, current_user)
    @user = user
    @form = form
    @current_user = current_user
  end

  # Method override.
  # Extract logic to another private method.
  def call
    return broadcast(:invalid) unless @form.valid?

    remove_user

    broadcast(:ok)
  end

  private

  attr_reader :user, :current_user

  # Method override.
  # Check if removed user is current user or not and registrate action.
  def remove_user
    if user != current_user
      Decidim.traceability.perform_action!(
        :delete,
        user,
        current_user
      ) do
        destroy_account
      end
    else
      destroy_account
    end
  end

  def destroy_account
    Decidim::User.transaction do
      destroy_user_account!
      destroy_user_identities
      destroy_user_group_memberships
      destroy_follows
      destroy_participatory_space_private_user
      delegate_destroy_to_participatory_spaces
    end
  end
end
