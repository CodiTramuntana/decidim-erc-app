# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Proposals
    describe ProposalSerializer do
      let!(:component) { create(:proposal_component) }
      let!(:amendable) { create(:proposal, component: component) }
      let!(:emendation) { create(:proposal, :unpublished, component: component) }
      let!(:amendment) { create(:amendment, :draft, amendable: amendable, emendation: emendation) }

      describe "#serialize" do
        let(:subject) { described_class.new(proposal).serialize }

        context "when the proposal is official" do
          let(:amendable) { create(:proposal, :official, component: component) }
          let(:proposal) { amendable }

          it { is_expected.to include(nickname: nil) }
        end

        context "when the proposal is an amendable" do
          let(:proposal) { amendable }

          it { is_expected.to include(nickname: proposal.creator_author.nickname) }
        end

        context "when the proposal is an emendation" do
          let(:proposal) { emendation }

          it { is_expected.to include(nickname: proposal.creator_author.nickname) }
        end
      end
    end
  end
end
