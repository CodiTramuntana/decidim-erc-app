# frozen_string_literal: true

module Decidim::Amendable::CreateFormDecorator
  def self.decorate
    Decidim::Amendable::CreateForm.class_eval do
      attribute :amendment_type, String
      attribute :sectorial_commission, Integer
      attribute :decidim_scope_id, Integer
      attribute :phone_number, String

      # Method overrided.
      # Assigns the :phone_number attribute value from the amender.
      def map_model(model)
        self.phone_number = Base64.decode64(model.amender.extended_data["phone_number"].to_s)
      end
    end
  end
end

::Decidim::Amendable::CreateFormDecorator.decorate
