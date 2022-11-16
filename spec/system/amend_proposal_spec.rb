# frozen_string_literal: true

require "rails_helper"

describe "Amend Proposal", versioning: true, type: :system do
  let!(:organization) { create(:organization, default_locale: "en") }
  let(:user) { create(:user, :confirmed, admin: admin, organization: organization) }
  let(:admin) { false }

  let!(:component) { create(:proposal_component, organization: organization) }
  let!(:active_step_id) { component.participatory_space.active_step.id }

  let!(:proposal) { create(:proposal, component: component) }
  let(:proposal_path) { Decidim::ResourceLocatorPresenter.new(proposal).path }

  let!(:emendation_same_scope) { create(:proposal, body: body, scope: user.scope, component: component) }
  let!(:amendment_same_scope) { create(:amendment, amendable: proposal, emendation: emendation_same_scope) }
  let!(:emendation_other_scope) { create(:proposal, component: component) }
  let!(:amendment_other_scope) { create(:amendment, amendable: proposal, emendation: emendation_other_scope) }

  before do
    switch_to_host(organization.host)
  end

  context "when amendments global setting is NOT enabled" do
    before do
      component.update!(settings: { amendments_enabled: false })
    end

    context "and amendments VISIBILITY step setting is set to 'scope'" do
      before do
        component.update!(step_settings: { active_step_id => { amendments_visibility: "scope" } })
      end

      context "when the user is logged in and visits an amended proposal" do
        before do
          login_as user, scope: :user
          visit proposal_path
        end

        it "is shown emendations of different scope in the amendments list" do
          within ".amendment-list" do
            expect(page).to have_content(translated(emendation_same_scope.title))
            expect(page).to have_content(translated(emendation_other_scope.title))
          end
        end

        it "is shown authors of emendation of different scope in the amenders list" do
          within ".amender-list" do
            expect(page).to have_content(amendment_same_scope.amender.nickname)
            expect(page).to have_content(amendment_other_scope.amender.nickname)
          end
        end
      end
    end

    context "when amendment REACTION is enabled" do
      before do
        component.update!(step_settings: { active_step_id => { amendment_reaction_enabled: true } })
      end

      context "and the proposal author visits an emendation to their proposal" do
        let(:user) { proposal.creator_author }
        let(:emendation_path) { Decidim::ResourceLocatorPresenter.new(emendation_same_scope).path }

        before do
          login_as user, scope: :user
          visit emendation_path
        end

        it "is NOT shown the accept and reject button" do
          expect(page).not_to have_css(".success", text: "ACCEPT")
          expect(page).not_to have_css(".alert", text: "REJECT")
        end
      end
    end
  end

  context "when amendments global setting IS enabled" do
    before do
      component.update!(settings: { amendments_enabled: true })
    end

    context "and amendments VISIBILITY step setting is set to 'scope'" do
      before do
        component.update!(step_settings: { active_step_id => { amendments_visibility: "scope" } })
      end

      context "when the user is logged in and visits an amended proposal" do
        before do
          login_as user, scope: :user
          visit proposal_path
        end

        it "is shown ONLY emendations of the same scope as the user in the amendments list" do
          within ".amendment-list" do
            expect(page).to have_content(translated(emendation_same_scope.title))
            expect(page).not_to have_content(translated(emendation_other_scope.title))
          end
        end

        it "is shown authors of emendation of the same scope as the user in the amenders list" do
          within ".amender-list" do
            expect(page).to have_content(amendment_same_scope.amender.nickname)
            expect(page).not_to have_content(amendment_other_scope.amender.nickname)
          end
        end

        context "when the user is admin" do
          let(:admin) { true }

          it "is shown emendations of different scope in the amendments list" do
            within ".amendment-list" do
              expect(page).to have_content(translated(emendation_other_scope.title))
            end
          end

          it "is shown authors of emendation of different scope in the amenders list" do
            within ".amender-list" do
              expect(page).to have_content(amendment_same_scope.amender.nickname)
              expect(page).to have_content(amendment_other_scope.amender.nickname)
            end
          end
        end
      end
    end

    context "when amendment REACTION is enabled" do
      let!(:emendation) { create(:proposal, title: { en: "Amended Long enough title" }, component: component) }
      let!(:amendment) { create :amendment, amendable: proposal, emendation: emendation }
      let(:emendation_path) { Decidim::ResourceLocatorPresenter.new(emendation).path }

      before do
        component.update!(step_settings: { active_step_id => { amendment_reaction_enabled: true } })
      end

      context "and the proposal author visits an emendation to their proposal" do
        let(:user) { proposal.creator_author }

        before do
          user.confirm
          login_as user, scope: :user
          visit emendation_path
        end

        it "is shown the accept and reject button" do
          expect(page).to have_css(".success", text: "ACCEPT")
          expect(page).to have_css(".alert", text: "REJECT")
        end

        context "when the user clicks on the accept button" do
          let(:emendation_title) { translated(emendation.title) }
          let(:emendation_body) { translated(emendation.body) }

          before do
            click_link "Accept"
          end

          it "is shown the amendment review form" do
            expect(page).to have_css(".edit_amendment")
            expect(page).to have_content("REVIEW THE AMENDMENT")
            expect(page).to have_field("Title", with: emendation_title)
            expect(page).to have_field("Body", with: emendation_body)
            expect(page).to have_button("Accept amendment")
          end

          context "and the emendation is accepted" do
            before do
              within ".edit_amendment" do
                click_button "Accept amendment"
              end
            end

            it "is shown the Success Callout" do
              expect(page).to have_css(".callout.success", text: "The amendment has been accepted successfully.")
            end

            it "is shown the accept and reject button again" do
              expect(page).to have_css(".success", text: "ACCEPT")
              expect(page).to have_css(".alert", text: "REJECT")
            end
          end
        end

        context "when the user clicks on the reject button" do
          let(:proposal_title) { translated(proposal.title) }

          before do
            click_link "Reject"
          end

          it "is shown the Success Callout" do
            expect(page).to have_css(".callout.success", text: "The amendment has been successfully rejected")
          end

          it "is shown the accept and reject button again" do
            expect(page).to have_css(".success", text: "ACCEPT")
            expect(page).to have_css(".alert", text: "REJECT")
          end
        end
      end
    end
  end
end
