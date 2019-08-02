# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Proposals
    describe EndorseProposal do
      let!(:component) { create(:proposal_component) }
      let!(:user) { create(:user, :confirmed, organization: component.organization) }
      let!(:user_group) { create(:user_group, :confirmed, :verified, organization: component.organization, users: [user]) }
      let!(:proposal) { create(:proposal, component: component) }
      let!(:emendation) { create(:proposal, component: component) }
      let!(:amendment) { create(:amendment, amendable: proposal, emendation: emendation) }

      let(:command) { described_class.new(resource, user, user_group_id) }

      describe "User endorses Proposal resource" do
        context "when the resource is an orginial proposal" do
          let(:resource) { proposal }

          context "and there is NO user group ID" do
            let(:user_group_id) { nil }

            it "broadcasts ok" do
              expect { command.call }.to broadcast(:ok)
            end
          end

          context "and there is a user group ID" do
            let(:user_group_id) { user_group.id }

            it "broadcasts ok" do
              expect { command.call }.to broadcast(:ok)
            end
          end
        end

        context "when the resource is an amendment" do
          let(:resource) { emendation }

          context "and there is NO user group ID" do
            let(:user_group_id) { nil }

            it "broadcasts invalid" do
              expect { command.call }.to broadcast(:invalid)
            end
          end

          context "and there is a user group ID" do
            let(:user_group_id) { user_group.id }

            context "and the proposal scope is different from the user scope" do
              it "broadcasts invalid" do
                expect { command.call }.to broadcast(:invalid)
              end
            end

            context "and the proposal scope is the same as the user scope" do
              before do
                emendation.update(scope: user.scope)
              end

              it "broadcasts ok" do
                expect { command.call }.to broadcast(:ok)
              end
            end
          end
        end
      end
    end
  end
end
