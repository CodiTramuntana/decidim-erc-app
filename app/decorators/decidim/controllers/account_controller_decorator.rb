# frozen_string_literal: true

# This decorator adds the logic to remove user from admin panel in participants.
Decidim::AccountController.class_eval do
  alias_method :original_destroy, :destroy

  def destroy
    if params[:user].present?
      enforce_permission_to :delete, :user, current_user: current_user

      @form = form(Decidim::DeleteAccountForm).from_params(params)
      user = Decidim::User.find(params[:user])

      Decidim::DestroyAccount.call(user, @form, current_user) do
        on(:ok) do
          flash[:notice] = t("account.destroy.success_", scope: "decidim")
        end

        on(:invalid) do
          flash[:alert] = t("account.destroy.error_", scope: "decidim")
        end
      end

      redirect_to decidim_admin.officializations_path
    else
      original_destroy
    end
  end
end
