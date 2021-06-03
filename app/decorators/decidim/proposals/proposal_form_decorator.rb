# frozen_string_literal: true

Decidim::Proposals::ProposalForm.class_eval do
  attribute :amendment_type, Array

  validates :amendment_type, presence: true
end
