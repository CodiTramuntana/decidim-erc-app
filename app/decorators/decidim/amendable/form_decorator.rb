# frozen_string_literal: true

Decidim::Amendable::Form.class_eval do
  # Method overrided.
  def emendation_must_change_amendable
    return unless %w(title body amendment_type).all? { |attr| attr.in? amendable_fields_as_string }

    emendation = amendable.class.new(emendation_params)
    return unless translated_attribute(amendable.title) == emendation.title
    return unless normalized_body(amendable) == normalized_body(emendation)

    amendable_form.errors.add(:title, :identical)
    amendable_form.errors.add(:body, :identical)
  end
end
