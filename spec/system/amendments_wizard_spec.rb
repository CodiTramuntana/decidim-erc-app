# frozen_string_literal: true

require "rails_helper"

describe "Amendment Wizard", type: :system do
  let!(:organization) { create(:organization, default_locale: "en") }
  let!(:user) do
    create(
      :user,
      :confirmed,
      organization: organization,
      extended_data: { "phone_number" => Base64.encode64("666-666-666") }
    )
  end
  let!(:component) { create(:proposal_component, :with_amendments_enabled, organization: organization) }
  let!(:active_step_id) { component.participatory_space.active_step.id }
  let!(:proposal) { create(:proposal, title: "More roads and less sidewalks", component: component) }

  let(:proposal_path) { Decidim::ResourceLocatorPresenter.new(proposal).path }
  let(:emendation_draft) { Decidim::Amendment.find_by(amendable: proposal.id, amender: user.id, state: "draft").emendation }

  let(:title) { "More sidewalks and less roads" }
  let(:body) { "Cities need more people, not more cars" }

  before do
    switch_to_host(organization.host)
  end

  context "when amending a proposal" do
    before do
      login_as user, scope: :user
      visit proposal_path
      click_link "Amend"
    end

    context "and in step_2: Compare your amendment" do
      context "with similar results" do
        let!(:emendation_other_scope) { create(:proposal, body: body, component: component) }
        let!(:amendment_other_scope) { create(:amendment, amendable: proposal, emendation: emendation_other_scope) }

        let!(:emendation_same_scope) { create(:proposal, body: body, scope: user.scope, component: component) }
        let!(:amendment_same_scope) { create(:amendment, amendable: proposal, emendation: emendation_same_scope) }

        before do
          component.update!(step_settings: { active_step_id => { amendments_visibility: "scope" } })
          within ".new_amendment" do
            fill_in :amendment_emendation_params_title, with: title
            fill_in :amendment_emendation_params_body, with: body
            find("*[type=submit]").click
          end
        end

        it "shows similar emendations only of the same scope" do
          within ".section-heading" do
            expect(page).to have_content("SIMILAR EMENDATIONS (1)")
          end

          within ".card-grid" do
            expect(page).to have_css(".card--proposal", count: 1)

            within ".card--proposal" do
              expect(page).to have_content(amendment_same_scope.amender.name)
              expect(page).to have_content(emendation_same_scope.title)

              expect(page).not_to have_content(emendation_other_scope.title)
              expect(page).not_to have_content(amendment_other_scope.amender.name)
            end
          end
        end
      end
    end

    context "and in step_3: Complete your amendment" do
      before do
        within ".new_amendment" do
          fill_in :amendment_emendation_params_title, with: title
          fill_in :amendment_emendation_params_body, with: body
          find("*[type=submit]").click
        end
      end

      it "show the phone_number field prefilled" do
        within ".edit_amendment" do
          expect(page).to have_field("Contact phone number", with: "666-666-666")
        end
      end

      context "when the user leaves the phone number field prefilled as is" do
        before do
          within ".edit_amendment" do
            find("*[type=submit]").click
          end
        end

        it "creates a proposal note" do
          expect(emendation_draft.proposal_notes_count).to eq(1)
          expect(Decidim::Proposals::ProposalNote.last.body).to eq("666-666-666")
        end
      end

      context "when the user fills the phone number field with another value" do
        before do
          within ".edit_amendment" do
            fill_in :amendment_phone_number, with: "999-999-999"
            find("*[type=submit]").click
          end
        end

        it "creates a proposal note" do
          expect(emendation_draft.proposal_notes_count).to eq(1)
          expect(Decidim::Proposals::ProposalNote.last.body).to eq("999-999-999")
        end
      end

      context "when the user empties the phone number field" do
        before do
          within ".edit_amendment" do
            fill_in :amendment_phone_number, with: ""
            find("*[type=submit]").click
          end
        end

        it "does NOT create a proposal note" do
          expect(emendation_draft.proposal_notes_count).to eq(0)
        end
      end
    end

    context "and in step_4: Preview your amendment" do
      before do
        within ".new_amendment" do
          fill_in :amendment_emendation_params_title, with: title
          fill_in :amendment_emendation_params_body, with: body
          find("*[type=submit]").click
        end
        within ".edit_amendment" do
          find("*[type=submit]").click
        end
      end

      context "when the Modify link is clicked" do
        before do
          click_link "Modify"
        end

        context "and the empties the phone number field" do
          before do
            within ".edit_amendment" do
              fill_in :amendment_phone_number, with: ""
              find("*[type=submit]").click
            end
          end

          it "deletes the proposal note" do
            expect(emendation_draft.reload.proposal_notes_count).to eq(0)
          end
        end

        context "and updates the phone number field" do
          before do
            within ".edit_amendment" do
              fill_in :amendment_phone_number, with: "999-999-999"
              find("*[type=submit]").click
            end
          end

          it "updates the proposal note" do
            expect(emendation_draft.proposal_notes_count).to eq(1)
            expect(Decidim::Proposals::ProposalNote.last.body).to eq("999-999-999")
          end
        end
      end
    end
  end
end
