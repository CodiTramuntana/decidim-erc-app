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
end
