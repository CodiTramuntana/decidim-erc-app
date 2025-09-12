# frozen_string_literal: true

module Decidim::Proposals::ProposalFormDecorator
  def self.decorate
    Decidim::Proposals::ProposalForm.class_eval do
      attribute :amendment_type, String
      attribute :sectorial_commission, Integer
    end
  end
end

::Decidim::Proposals::ProposalFormDecorator.decorate
