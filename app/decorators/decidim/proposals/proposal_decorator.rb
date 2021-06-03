# frozen_string_literal: true

Decidim::Proposals::Proposal.class_eval do
  amendable(
    fields: [:title, :body, :amendment_type],
    form: "Decidim::Proposals::ProposalForm"
  )
end
