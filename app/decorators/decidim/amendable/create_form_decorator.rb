# frozen_string_literal: true

module Decidim::Amendable::CreateFormDecorator
  def self.decorate
    Decidim::Amendable::CreateForm.class_eval do
      attribute :amendment_type, String
      attribute :sectorial_commission, Integer
      attribute :decidim_scope_id, Integer
    end
  end
end

::Decidim::Amendable::CreateFormDecorator.decorate
