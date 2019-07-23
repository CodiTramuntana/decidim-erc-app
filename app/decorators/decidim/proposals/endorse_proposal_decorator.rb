# frozen_string_literal: true

# This decorator adds the logic to prevent endorsing a proposal
# for special cases related to the ERC app customizations.
Decidim::Proposals::EndorseProposal.class_eval do
  # Method overrided.
  # Add guard clause for emendations: cannot endorse without user group or with different scope.
  def call
    return broadcast(:invalid) if @proposal.emendation? && (@current_group_id.nil? || @proposal.scope != @current_user.scope)

    endorsement = build_proposal_endorsement
    if endorsement.save
      notify_endorser_followers
      broadcast(:ok, endorsement)
    else
      broadcast(:invalid)
    end
  end
end
