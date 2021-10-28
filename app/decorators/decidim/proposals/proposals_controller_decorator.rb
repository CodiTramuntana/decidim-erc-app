# frozen_string_literal: true

Decidim::Proposals::ProposalsController.class_eval do
  alias_method :original_index, :index

  def index
    if component_settings.participatory_texts_enabled?
      @proposals = Decidim::Proposals::Proposal
                   .where(component: current_component)
                   .published
                   .not_hidden
                   .only_amendables
                   .includes(:category, :scope)
                   .order(position: :asc)

      Rails.application.config.session_options[:erc_participatory_texts_scope_id] = params[:scope_id] if params.has_key?(:scope_id)

      render "decidim/proposals/proposals/participatory_texts/participatory_text"
    else
      @base_query = search
                    .results
                    .published
                    .not_hidden

      @proposals = @base_query.includes(:amendable, :category, :component, :resource_permission, :scope)
      @all_geocoded_proposals = @base_query.geocoded

      @voted_proposals = if current_user
                           Decidim::Proposals::ProposalVote.where(
                             author: current_user,
                             proposal: @proposals.pluck(:id)
                           ).pluck(:decidim_proposal_id)
                         else
                           []
                         end
      @proposals = paginate(@proposals)
      @proposals = reorder(@proposals)
    end
  end
end
