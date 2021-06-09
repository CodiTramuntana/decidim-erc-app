# frozen_string_literal: true

Decidim::Proposals::ProposalForm.class_eval do
  attribute :amendment_type, String

  validates :amendment_type, presence: true
end
