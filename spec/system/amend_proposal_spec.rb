# frozen_string_literal: true

require "rails_helper"

describe "Amend Proposal", type: :system do
  let!(:organization) { create(:organization, default_locale: "en") }
  let!(:user) { create :user, :confirmed, organization: organization }
  let!(:component) { create(:proposal_component, organization: organization) }
  let!(:active_step_id) { component.participatory_space.active_step.id }
  let!(:proposal) { create(:proposal, component: component) }
  let(:proposal_path) { Decidim::ResourceLocatorPresenter.new(proposal).path }

  before do
    switch_to_host(organization.host)
  end

  context "with existing amendments" do
    let!(:emendation_same_scope) { create(:proposal, body: body, scope: user.scope, component: component) }
    let!(:amendment_same_scope) { create(:amendment, amendable: proposal, emendation: emendation_same_scope) }

    let!(:emendation_other_scope) { create(:proposal, component: component) }
    let!(:amendment_other_scope) { create(:amendment, amendable: proposal, emendation: emendation_other_scope) }

    context "and amendments global setting is NOT enabled" do
      before do
        component.update!(settings: { amendments_enabled: false })
      end

      context "when amendments VISIBILITY step setting is set to 'scope'" do
        before do
          component.update!(step_settings: { active_step_id => { amendments_visibility: "scope" } })
        end

        context "when the user is logged in" do
          before do
            login_as user, scope: :user
            visit proposal_path
          end

          context "and visit an amendable proposal" do
            it "is shown emendations of different scope in the amendments list" do
              within ".amendment-list" do
                expect(page).to have_content(emendation_other_scope.title)
              end
            end

            it "is shown authors of emendation of different scope in the amenders list" do
              within ".amender-list" do
                expect(page).to have_content(amendment_other_scope.amender.name)
              end
            end
          end
        end
      end
    end

    context "and amendments global setting IS enabled" do
      before do
        component.update!(settings: { amendments_enabled: true })
      end

      context "when amendments VISIBILITY step setting is set to 'scope'" do
        before do
          component.update!(step_settings: { active_step_id => { amendments_visibility: "scope" } })
        end

        context "when the user is logged in" do
          before do
            login_as user, scope: :user
            visit proposal_path
          end

          context "and visit an amendable proposal" do
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
          end
        end
      end
    end
  end
end
