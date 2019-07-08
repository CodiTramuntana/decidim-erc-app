# frozen_string_literal: true

Decidim::Amendable::UpdateDraft.class_eval do
  def call
    return broadcast(:invalid) unless form.valid? && amendment.draft? && amender == current_user

    transaction do
      update_draft
      handle_proposal_note
    end

    broadcast(:ok, @amendment)
  end

  private

  # Adds the scope of the user to the emendation.
  def update_draft
    PaperTrail.request(enabled: false) do
      emendation.update(form.emendation_params.merge(scope: current_user.scope))
      emendation.coauthorships.clear
      emendation.add_coauthor(current_user, user_group: user_group)
    end
  end

  # Creates and/or updates or deletes the ProposalNote with the phone number.
  def handle_proposal_note
    proposal_note = Decidim::Proposals::ProposalNote.find_or_initialize_by(proposal: emendation, author: current_user)

    if form.phone_number.present?
      proposal_note&.update(body: form.phone_number)
    else
      proposal_note&.delete
      Decidim::Proposals::Proposal.reset_counters(emendation.id, :proposal_notes_count)
    end
  end
end
