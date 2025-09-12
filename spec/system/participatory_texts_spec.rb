# frozen_string_literal: true

require "rails_helper"

describe "Participatory texts", type: :system do
  include Decidim::SanitizeHelper
  include ActionView::Helpers::TextHelper

  include_context "with a component"
  let(:manifest_name) { "proposals" }
  let(:current_user) { create(:user, :confirmed, admin: true, organization:) }
  let!(:scopes) do
    create_list(:scope, 5, organization:)
  end
  let!(:active_step_id) { component.participatory_space.active_step.id }

  context "when listing proposals in a participatory process as participatory texts" do
    context "when admin has published a participatory text" do
      let!(:participatory_text) { create :participatory_text, component: }
      let!(:proposals) { create_list(:proposal, 3, :published, component:) }
      let!(:component) do
        create(:proposal_component,
               :with_participatory_texts_enabled,
               manifest:,
               participatory_space: participatory_process)
      end
      let!(:emendation) { create(:proposal, :published, component:, scope: scopes.first) }
      let!(:amendment) { create :amendment, amendable: proposals.first, emendation: }
      let!(:other_emendation) { create(:proposal, component:, scope: scopes.second) }
      let!(:other_amendment) { create(:amendment, amendable: proposals.first, emendation: other_emendation) }

      before do
        login_as current_user, scope: :user
        component.update!(
          settings: component.settings.to_h.merge(amendments_enabled: true),
          step_settings: { active_step_id => { amendments_visibility: "scope" } }
        )
        visit_component
      end

      it "renders the participatory text title" do
        expect(page).to have_content(translated(participatory_text.title))
      end

      it "renders the scope filter" do
        expect(page).to have_content(translated("Filter by scope"))
      end

      context "when admin select an scope and amendments VISIBILITY step setting is set to 'scope'" do
        let(:amendments_count) { 1 }
        let(:disabled_value) { false }

        it "renders scope list and select one scope and amend counter is correct" do
          page.find(".filter-by-scope").click
          expect(page).to have_content(translated(scopes.first.name))

          click_link translated(scopes.first.name)
          expect(page).to have_content(translated(participatory_text.title))

          proposal_title = translated(proposals.first.title)
          find("#proposals section[id^='proposal']", text: proposal_title).hover
          within all("#proposals section[id^='proposal']").first, visible: :visible do
            expect(page).to have_link("Amend")
            expect(page).to have_link(amendments_count)
          end
        end

        it "renders scope list and select all scopes and amend counter is correct" do
          page.find(".filter-by-scope").click
          expect(page).to have_content(translated(scopes.first.name))

          click_link translated("All scopes")
          expect(page).to have_content(translated(participatory_text.title))

          proposal_title = translated(proposals.first.title)
          find("#proposals section[id^='proposal']", text: proposal_title).hover
          within all("#proposals section[id^='proposal']").first, visible: :visible do
            expect(page).to have_link("Amend")
            expect(page).to have_link(2)
          end
        end
      end

      context "when admin select an index" do
        let(:amendments_count) { 1 }
        let(:disabled_value) { false }

        it "renders index list and select an index" do
          find("strong", text: "See index").click
          expect(page).to have_content(translated(proposals.first.title))

          find("u", text: translated(proposals.first.title)).click
          expect(page).to have_content(translated(proposals.first.title))
          expect(page).to have_content("Back to list")
        end
      end
    end
  end
end
