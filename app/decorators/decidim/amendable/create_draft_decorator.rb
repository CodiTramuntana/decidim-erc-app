# frozen_string_literal: true

Decidim::Amendable::CreateDraft.class_eval do
  # Method overrided.
  # Add amendment_type to an emendation
  def create_emendation!
    PaperTrail.request(enabled: false) do
      @emendation = Decidim.traceability.perform_action!(
        :create,
        amendable.class,
        current_user,
        visibility: "public-only"
      ) do
        emendation = amendable.class.new(form.emendation_params)
        emendation.title = { I18n.locale => form.emendation_params.with_indifferent_access[:title] }
        emendation.body = { I18n.locale => form.emendation_params.with_indifferent_access[:body] }
        emendation.amendment_type = form.amendment_type
        emendation.component = amendable.component
        emendation.add_author(current_user, user_group)
        emendation.save!
        emendation
      end
    end
  end
end
