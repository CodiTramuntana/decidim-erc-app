# frozen_string_literal: true

Decidim::Proposals::ProposalForm.class_eval do
  attribute :amendment_type, String
  attribute :sectorial_commission, Integer
end
