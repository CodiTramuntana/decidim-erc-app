# frozen_string_literal: true

module Decidim::Proposals::ProposalsControllerDecorator
  def self.decorate
    Decidim::Proposals::ProposalsController.class_eval do
      alias_method :original_index, :index
    
      def index
        if component_settings.participatory_texts_enabled?
          @proposals = Decidim::Proposals::Proposal
                       .where(component: current_component)
                       .published
                       .not_hidden
                       .only_amendables
                       .includes(:category, :scope, :attachments, :coauthorships)
                       .order(position: :asc)
    
          Rails.application.config.session_options[:erc_participatory_texts_scope_id] = params[:scope_id] if params.has_key?(:scope_id)
    
          render "decidim/proposals/proposals/participatory_texts/participatory_text"
        else
          original_index
        end
      end
    end
  end
end

::Decidim::Proposals::ProposalsControllerDecorator.decorate
