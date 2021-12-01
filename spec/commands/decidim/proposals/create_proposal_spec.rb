# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Proposals
    describe CreateProposal do
      let(:form_klass) { ProposalWizardCreateStepForm }
      let(:component) { create(:proposal_component) }
      let(:organization) { component.organization }
      let(:user) { create :user, :admin, :confirmed, organization: organization }
      let(:form) do
        form_klass.from_params(
          form_params
        ).with_context(
          current_user: user,
          current_organization: organization,
          current_participatory_space: component.participatory_space,
          current_component: component
        )
      end

      let(:author) { create(:user, organization: organization) }

      let(:user_group) do
        create(:user_group, :verified, organization: organization, users: [author])
      end

      describe "call" do
        let(:form_params) do
          {
            title: "A reasonable proposal title",
            body: "A reasonable proposal body",
            user_group_id: user_group.try(:id)
          }
        end

        let(:command) do
          described_class.new(form, author)
        end

        describe "when the form is not valid" do
          before do
            expect(form).to receive(:invalid?).and_return(true)
          end

          it "broadcasts invalid" do
            expect { command.call }.to broadcast(:invalid)
          end

          it "doesn't create a proposal" do
            expect do
              command.call
            end.not_to change(Decidim::Proposals::Proposal, :count)
          end
        end

        describe "when the form is valid" do
          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "creates a new proposal" do
            expect do
              command.call
            end.to change(Decidim::Proposals::Proposal, :count).by(1)
          end

          it "sets the body and title as i18n" do
            command.call
            proposal = Decidim::Proposals::Proposal.last

            expect(proposal.title).to be_kind_of(Hash)
            expect(proposal.title[I18n.locale.to_s]).to eq form_params[:title]
            expect(proposal.body).to be_kind_of(Hash)
            expect(proposal.body[I18n.locale.to_s]).to eq form_params[:body]
          end
        end
      end
    end
  end
end
