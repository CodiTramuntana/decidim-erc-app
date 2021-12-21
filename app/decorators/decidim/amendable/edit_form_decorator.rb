# frozen_string_literal: true

# This decorator adds the management of the `phone_number` form field.
Decidim::Amendable::EditForm.class_eval do
  # Attribute added.
  attribute :phone_number, String
  attribute :amendment_type, String
  attribute :sectorial_commission, String

  # Method overrided.
  # Injects the scope of the user into the emendation_params.
  def before_validation
    self.emendation_params = emendation_params.merge(scope: current_user.scope)
  end

  # Method overrided.
  # Assigns the :phone_number attribute value from the amender.
  def map_model(model)
    self.emendation_params = model.emendation.attributes.slice(*amendable_fields_as_string)
    self.phone_number = Base64.decode64(model.amender.extended_data["phone_number"].to_s)
  end
end
