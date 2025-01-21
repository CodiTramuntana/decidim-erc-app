# frozen_string_literal: true

# This decorator adds the logic to remove user from admin panel in participants.
module Decidim::Admin::OfficializationsControllerDecorator
  def self.decorate
    Decidim::Admin::OfficializationsController.class_eval do
      def destroy_participant
        enforce_permission_to :delete, :user
    
        @form = form(Decidim::DeleteAccountForm).from_params(params)
        user = Decidim::User.find(params[:user_id])
    
        Decidim::User.transaction do
          Decidim.traceability.perform_action!(:delete, user, current_user)
          Decidim::DestroyUserAccount.call(@form, user ) do
            on(:ok) do
              flash[:notice] = t("account.destroy.success_", scope: "decidim")
            end
    
            on(:invalid) do
              flash[:alert] = t("account.destroy.error", scope: "decidim")
            end
          end
        end
    
        redirect_to decidim_admin.officializations_path
      end
    end
  end
end

::Decidim::Admin::OfficializationsControllerDecorator.decorate
