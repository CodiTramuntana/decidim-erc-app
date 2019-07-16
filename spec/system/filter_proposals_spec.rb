# frozen_string_literal: true

require "rails_helper"

describe "Filter Proposals", type: :system do
  let!(:organization) { create(:organization, default_locale: "en") }
  let!(:other_scope) { create(:scope, organization: organization) }
  let!(:scope) { create(:scope, organization: organization) }
  let!(:user) { create :user, :confirmed, organization: organization, extended_data: { "member_of": scope.id } }

  let!(:component) { create(:proposal_component, organization: organization) }
  let!(:active_step_id) { component.participatory_space.active_step.id }
  let!(:proposal) { create(:proposal, component: component) }

  before do
    switch_to_host(organization.host)
  end

  context "when filtering proposals by TYPE" do
    context "when amendments global setting IS enabled" do
      before do
        component.update!(settings: { amendments_enabled: true })
      end

      context "and amendments VISIBILITY step setting is set to 'scope'" do
        before do
          component.update!(step_settings: { active_step_id => { amendments_visibility: "scope" } })
        end

        context "when the user is logged in" do
          context "and there are emendations with same scope as the user" do
            let!(:emendation_same_scope) { create(:proposal, body: body, scope: scope, component: component) }
            let!(:amendment_same_scope) { create(:amendment, amendable: proposal, emendation: emendation_same_scope) }

            let!(:emendation_other_scope) { create(:proposal, scope: other_scope, component: component) }
            let!(:amendment_other_scope) { create(:amendment, amendable: proposal, emendation: emendation_other_scope) }

            before do
              login_as user, scope: :user
              visit main_component_path(component)
            end

            it "can be filtered by type" do
              within "form.new_filter" do
                expect(page).to have_content(/Type/i)
              end
            end

            it "lists emendations of the same scope as the user" do
              within ".filters" do
                choose "Amendments"
              end

              expect(page).to have_css(".card.card--proposal", count: 1)
              expect(page).to have_content("1 PROPOSAL")
              expect(page).to have_content("AMENDMENT", count: 1)
              expect(page).to have_content(emendation_same_scope.title)
              expect(page).to have_no_content(emendation_other_scope.title)
            end
          end

          context "and there are NO emendations with same scope as the user" do
            let!(:emendation_other_scope) { create(:proposal, scope: other_scope, component: component) }
            let!(:amendment_other_scope) { create(:amendment, amendable: proposal, emendation: emendation_other_scope) }

            before do
              login_as user, scope: :user
              visit main_component_path(component)
            end

            it "cannot be filtered by type" do
              within "form.new_filter" do
                expect(page).to have_no_content(/Type/i)
              end
            end
          end
        end
      end
    end

    context "when amendments_enabled component setting is NOT enabled" do
      before do
        component.update!(settings: { amendments_enabled: false })
      end

      context "and amendments VISIBILITY step setting is set to 'scope'" do
        before do
          component.update!(step_settings: { active_step_id => { amendments_visibility: "scope" } })
        end

        context "when the user is logged in" do
          context "and there are emendations with same scope as the user" do
            let!(:emendation_same_scope) { create(:proposal, body: body, scope: scope, component: component) }
            let!(:amendment_same_scope) { create(:amendment, amendable: proposal, emendation: emendation_same_scope) }

            let!(:emendation_other_scope) { create(:proposal, scope: other_scope, component: component) }
            let!(:amendment_other_scope) { create(:amendment, amendable: proposal, emendation: emendation_other_scope) }

            before do
              login_as user, scope: :user
              visit main_component_path(component)
            end

            it "can be filtered by type" do
              within "form.new_filter" do
                expect(page).to have_content(/Type/i)
              end
            end

            it "lists all the amendments" do
              within ".filters" do
                choose "Amendments"
              end
              expect(page).to have_css(".card.card--proposal", count: 2)
              expect(page).to have_content("2 PROPOSAL")
              expect(page).to have_content("AMENDMENT", count: 2)
              expect(page).to have_content(emendation_same_scope.title)
              expect(page).to have_content(emendation_other_scope.title)
            end
          end

          context "and there are NO emendations with same scope as the user" do
            let!(:emendation_other_scope) { create(:proposal, scope: other_scope, component: component) }
            let!(:amendment_other_scope) { create(:amendment, amendable: proposal, emendation: emendation_other_scope) }

            before do
              login_as user, scope: :user
              visit main_component_path(component)
            end

            it "can be filtered by type" do
              within "form.new_filter" do
                expect(page).to have_content(/Type/i)
              end
            end
          end
        end
      end
    end
  end
end
