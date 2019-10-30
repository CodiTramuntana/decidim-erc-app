# frozen_string_literal: true

require "rails_helper"

describe "Amend Proposal", type: :system do
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
            expect(page).to have_content(emendation_same_scope.title)
            expect(page).to have_content(emendation_other_scope.title)
          end
        end

        it "is shown authors of emendation of different scope in the amenders list" do
          within ".amender-list" do
            expect(page).to have_content(amendment_same_scope.amender.name)
            expect(page).to have_content(amendment_other_scope.amender.name)
          end
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
            expect(page).to have_content(emendation_same_scope.title)
            expect(page).not_to have_content(emendation_other_scope.title)
          end
        end

        it "is shown authors of emendation of the same scope as the user in the amenders list" do
          within ".amender-list" do
            expect(page).to have_content(amendment_same_scope.amender.name)
            expect(page).not_to have_content(amendment_other_scope.amender.name)
          end
        end

        context "when the user is admin" do
          let(:admin) { true }

          it "is shown emendations of different scope in the amendments list" do
            within ".amendment-list" do
              expect(page).to have_content(emendation_same_scope.title)
              expect(page).to have_content(emendation_other_scope.title)
            end
          end

          it "is shown authors of emendation of different scope in the amenders list" do
            within ".amender-list" do
              expect(page).to have_content(amendment_same_scope.amender.name)
              expect(page).to have_content(amendment_other_scope.amender.name)
            end
          end
        end
      end
    end
  end
end
