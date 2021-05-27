# frozen_string_literal: true

# This decorator handles the creation of a ProposalNote with the phone_number.
Decidim::Amendable::UpdateDraft.class_eval do
  # Method overrided.
  # Modifies the transaction block to include a new method.
  def call
    return broadcast(:invalid) unless form.valid? && amendment.draft? && amender == current_user

    transaction do
      update_draft
      create_proposal_note
    end

    broadcast(:ok, @amendment)
  end

  private

  # Method added.
  # Creates a ProposalNote with the phone number.
  def create_proposal_note
    Decidim::Proposals::ProposalNote.find_or_create_by(
      proposal: emendation,
      author: current_user,
      body: form.phone_number.to_s
    )
  end
end
