# frozen_string_literal: true

Decidim::Proposals::EndorseProposal.class_eval do
  def call
    return broadcast(:invalid) if @proposal.emendation? && @current_group_id.nil?

    endorsement = build_proposal_endorsement
    if endorsement.save
      notify_endorser_followers
      broadcast(:ok, endorsement)
    else
      broadcast(:invalid)
    end
  end
end
