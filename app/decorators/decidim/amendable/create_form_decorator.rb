# frozen_string_literal: true

Decidim::Amendable::CreateForm.class_eval do
  attribute :amendment_type, String
  attribute :sectorial_commission, String
end
