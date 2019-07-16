# frozen_string_literal: true

# This decorator adds the management of the `phone_number` form field.
Decidim::Amendable::EditForm.class_eval do
  # Attribute added.
  attribute :phone_number, String

  # Method overrided.
  # Assigns the :phone_number attribute value from the amender.
  def map_model(model)
    self.emendation_params = model.emendation.attributes.slice(*amendable_fields_as_string)
    self.phone_number = model.amender.phone_number
  end

  # Method added.
  # ProposalNote created in Decidim::Amendable::UpdateDraft.
  def proposal_note
    @proposal_note ||= Decidim::Proposals::ProposalNote.find_by(proposal: emendation, author: current_user)
  end

  # Method added.
  # The value to render in the :phone_number field at app/views/decidim/amendments/edit_draft.html.erb
  def phone_number_value
    proposal_note&.body || phone_number
  end
end
