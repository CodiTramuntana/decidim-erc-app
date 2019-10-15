# frozen_string_literal: true

# This decorator updates the draft with scope of the user and handles the
# creation of a ProposalNote that contains the `phone_number` String.
Decidim::Amendable::UpdateDraft.class_eval do
  # Method overrided.
  # Modifies transaction block to include new method
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
  # Adds the scope of the user to the emendation.
  def update_draft
    PaperTrail.request(enabled: false) do
      emendation.update(form.emendation_params.merge(scope: current_user.scope))
      emendation.coauthorships.clear
      emendation.add_coauthor(current_user, user_group: user_group)
    end
  end

  # Method added.
  # Creates a ProposalNote with the phone number.
  def create_proposal_note
    Decidim::Proposals::ProposalNote.find_or_create_by(
      proposal: emendation,
      author: current_user,
      body: form.phone_number
    )
  end
end
