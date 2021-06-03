# frozen_string_literal: true

Decidim::Amendable::CreateDraft.class_eval do
  # Method overrided.
  # Set amendment_type in original proposal
  def call
    set_amendment_type
    return broadcast(:invalid) if form.invalid?

    transaction do
      create_emendation!
      create_amendment!
    end

    broadcast(:ok, @amendment)
  end

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
        emendation.amendment_type = form.emendation_params.with_indifferent_access[:amendment_type]
        emendation.component = amendable.component
        emendation.add_author(current_user, user_group)
        emendation.save!
        emendation
      end
    end
  end

  private

  def set_amendment_type
    amendable.amendment_type = "original"
  end
end
