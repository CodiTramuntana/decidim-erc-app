# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/participatory_processes/test/factories"
require "decidim/proposals/test/factories"
require "decidim/meetings/test/factories"

# Modify factories :user and :proposal to add a scope by default.
FactoryBot.modify do
  factory :user, class: "Decidim::User" do
    scope { create(:scope, organization: organization) } # Adding this.
  end

  factory :proposal, class: "Decidim::Proposals::Proposal" do
    after(:build) do |proposal, evaluator|
      if proposal.component
        users = evaluator.users || [create(:user, organization: proposal.component.participatory_space.organization)]
        users.each_with_index do |user, idx|
          user_group = evaluator.user_groups[idx]
          proposal.coauthorships.build(author: user, user_group: user_group)
          proposal.scope ||= user.scope # Adding this.
        end
      end
    end
  end
end
