# frozen_string_literal: true

# Reopen the class to include a concern that overrides another concern.
require Decidim::Proposals::Engine.root.join("app/models/decidim/proposals/proposal.rb").to_s

# The following methods have been modified to handle an additional component
# step setting amendments_visibility option:
# -  ::only_visible_emendations_for(user, component)
# -  ::amendables_and_visible_emendations_for(user, component)
# -  #visible_emendations_for(user)
#
# The new option "scope" allows to filter emendations by the scope of the user.
module AmendableExtension
  extend ActiveSupport::Concern

  included do
    # retrieves resources that are emendations and visible to the user
    # based on the component's amendments settings.
    scope :only_visible_emendations_for, lambda { |user, component|
      return only_emendations unless component.settings.amendments_enabled
      return only_emendations if user&.admin?

      case component.current_settings.amendments_visibility
      when "participants"
        return none unless user

        where(id: joins(:amendable).where("decidim_amendments.decidim_user_id = ?", user.id))
      when "scope"
        return none unless user

        where(id: joins(:amendable).where(scope: user.scope))
      else # Assume 'all'
        only_emendations
      end
    }
    # retrieves both resources that are amendables and emendations filtering out the emendations
    # that are not visible to the user based on the component's amendments settings.
    scope :amendables_and_visible_emendations_for, lambda { |user, component|
      return all unless component.settings.amendments_enabled
      return all if user&.admin?

      case component.current_settings.amendments_visibility
      when "participants"
        return only_amendables unless user

        where.not(id: joins(:amendable).where.not("decidim_amendments.decidim_user_id = ?", user.id))
      when "scope"
        return only_amendables unless user

        where.not(id: joins(:amendable).where.not(scope: user.scope))
      else # Assume 'all'
        all
      end
    }
  end

  def self.included(base)
    base.include InstanceMethods
  end

  module InstanceMethods
    # Returns the emendations of an amendable that are visible to the user
    # based on the component's amendments settings.
    def visible_emendations_for(user)
      published_emendations = emendations.published
      return published_emendations unless component.settings.amendments_enabled

      case component.current_settings.amendments_visibility
      when "participants"
        return self.class.none unless user

        published_emendations.where("decidim_amendments.decidim_user_id = ?", user.id)
      when "scope"
        return self.class.none unless user

        if user&.admin?
          scope_id = Rails.application.config.session_options[:erc_participatory_texts_scope_id]

          if scope_id.present?
            published_emendations.where(decidim_scope_id: scope_id)
          else
            published_emendations
          end
        else
          published_emendations.where(scope: user.scope)
        end
      else # Assume 'all'
        published_emendations
      end
    end
  end
end

Decidim::Proposals::Proposal.send(:include, AmendableExtension)
