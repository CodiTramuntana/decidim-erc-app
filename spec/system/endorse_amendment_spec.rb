# frozen_string_literal: true

require "rails_helper"

describe "Endorse Amendment", versioning: true, type: :system do
  let!(:organization) { create(:organization, default_locale: "en") }
  let!(:user) { create(:user, :confirmed, organization: organization) }
  let!(:user_group) { create(:user_group, :confirmed, :verified, organization: organization) }
  let!(:component) { create(:proposal_component, organization: organization) }
  let!(:proposal) { create(:proposal, component: component) }

  let(:active_step_id) { component.participatory_space.active_step.id }
  let(:proposal_path) { Decidim::ResourceLocatorPresenter.new(proposal).path }
  let(:emendation_path) { Decidim::ResourceLocatorPresenter.new(emendation).path }

  before do
    switch_to_host(organization.host)
  end

  context "when the user is logged in" do
    before do
      login_as user, scope: :user
    end

    context "and IS a manager of user group" do
      let!(:manager_membership) { create(:user_group_membership, user: user, user_group: user_group, role: :admin) }

      context "and visits an amendment of the same scope" do
        let!(:emendation) { create(:proposal, scope: user.scope, component: component) }
        let!(:amendment) { create(:amendment, amendable: proposal, emendation: emendation) }

        before do
          visit emendation_path
        end

        it "shows the endorse button and endorsements count" do
          expect(page).to have_button("Endorse")
          expect(page).to have_css("#resource-#{emendation.id}-endorsements-count")
        end

        context "when the user clicks the Endorse button" do
          before do
            click_button "Endorse"
          end

          it "is able to endorse only as a user group" do
            within "#user-identities" do
              expect(page).to have_content(user_group.nickname)
              expect(page).not_to have_content(user.nickname)
              find("li").click
            end

            within "#resource-#{emendation.id}-endorsements-count" do
              expect(page).to have_content("1")
            end
          end
        end
      end

      context "and visits an amendment of a different scope" do
        let!(:emendation) { create(:proposal, component: component) }
        let!(:amendment) { create(:amendment, amendable: proposal, emendation: emendation) }

        before do
          visit emendation_path
        end

        it "doesn't show the endorse proposal button" do
          expect(page).to have_no_button("Endorse")
        end

        it "doesn't show the endorsements count" do
          expect(page).to have_no_css("#resource-#{emendation.id}-endorsements-count")
        end
      end

      context "and visits a proposal" do
        before do
          visit proposal_path
        end

        it "shows the endorse button and endorsements count" do
          expect(page).to have_button("Endorse")
          expect(page).to have_css("#resource-#{proposal.id}-endorsements-count")
        end

        context "when the user clicks the Endorse button" do
          before do
            click_button "Endorse"
          end

          it "is able to endorse both as user and user group" do
            within "#user-identities" do
              expect(page).to have_content(user_group.nickname)
              expect(page).to have_content(user.nickname)
              all("li").first.click
            end

            within "#resource-#{proposal.id}-endorsements-count" do
              expect(page).to have_content("1")
            end
          end
        end
      end
    end

    context "and is NOT a manager of user group" do
      let!(:member_membership) { create(:user_group_membership, user: user, user_group: user_group, role: :member) }

      context "and visits an amendment of the same scope" do
        let!(:emendation) { create(:proposal, scope: user.scope, component: component) }
        let!(:amendment) { create(:amendment, amendable: proposal, emendation: emendation) }

        before do
          visit emendation_path
        end

        it "doesn't show the endorse proposal button" do
          expect(page).to have_no_button("Endorse")
        end

        it "doesn't show the endorsements count" do
          expect(page).to have_no_css("#resource-#{emendation.id}-endorsements-count")
        end
      end

      context "and visits an amendment of a different scope" do
        let!(:emendation) { create(:proposal, component: component) }
        let!(:amendment) { create(:amendment, amendable: proposal, emendation: emendation) }

        before do
          visit emendation_path
        end

        it "doesn't show the endorse proposal button" do
          expect(page).to have_no_button("Endorse")
        end

        it "doesn't show the endorsements count" do
          expect(page).to have_no_css("#resource-#{emendation.id}-endorsements-count")
        end
      end

      context "and visits a proposal" do
        before do
          visit proposal_path
        end

        it "shows the endorse button and endorsements count" do
          expect(page).to have_button("Endorse")
          expect(page).to have_css("#resource-#{proposal.id}-endorsements-count")
        end

        context "when the user clicks the Endorse button" do
          before do
            click_button "Endorse"
          end

          it "is endorses the proposal as user" do
            within "#resource-#{proposal.id}-endorsements-count" do
              expect(page).to have_content("1")
            end
          end
        end
      end
    end
  end
end
