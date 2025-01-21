# frozen_string_literal: true

# This decorator adds the logic to prevent endorsing
# for special cases related to the ERC app customizations.
module Decidim::Commands::EndorseResourceDecorator
  def self.decorate
    Decidim::EndorseResource.class_eval do
      # Method overrided.
      # Add guard clause for emendations: cannot endorse without user group.
      def call
        return broadcast(:invalid) if existing_group_endorsement? && resource.emendation? && (@current_group_id.nil? || resource.scope != @current_user.scope)
    
        endorsement = build_resource_endorsement
        if endorsement.save
          notify_endorser_followers
          broadcast(:ok, endorsement)
        else
          broadcast(:invalid)
        end
      rescue ActiveRecord::RecordNotUnique
        broadcast(:invalid)
      end
    end
  end
end

::Decidim::Commands::EndorseResourceDecorator.decorate
