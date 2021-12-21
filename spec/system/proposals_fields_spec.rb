# frozen_string_literal: true

require "rails_helper"

describe "Proposals", type: :system do
  include_context "with a component"
  let(:manifest_name) { "proposals" }

  let!(:category) { create :category, participatory_space: participatory_process }
  let!(:scope) { create :scope, organization: organization }
  let!(:user) { create :user, :confirmed, organization: organization }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization: organization, scope: scope) }

  let(:proposal_title) { "More sidewalks and less roads" }
  let(:proposal_body) { "Cities need more people, not more cars" }

  matcher :have_author do |name|
    match { |node| node.has_selector?(".author-data", text: name) }
    match_when_negated { |node| node.has_no_selector?(".author-data", text: name) }
  end

  context "when creating a new proposal" do
    let(:scope_picker) { select_data_picker(:proposal_scope_id) }

    context "when the user is logged in" do
      before do
        login_as user, scope: :user
      end

      context "with creation enabled" do
        let!(:component) do
          create(:proposal_component,
                 :with_creation_enabled,
                 manifest: manifest,
                 participatory_space: participatory_process,
                 settings: { scopes_enabled: true, scope_id: participatory_process.scope&.id })
        end

        let(:proposal_draft) { create(:proposal, :draft, component: component) }

        context "when attachments are allowed", processing_uploads_for: Decidim::AttachmentUploader do
          let!(:component) do
            create(:proposal_component,
                   :with_creation_enabled,
                   :with_attachments_allowed,
                   manifest: manifest,
                   participatory_space: participatory_process)
          end

          let(:proposal_draft) { create(:proposal, :draft, users: [user], component: component, title: "Proposal with attachments", body: "This is my proposal and I want to upload attachments.") }

          it "creates a new proposal with attachments" do
            visit complete_proposal_path(component, proposal_draft)

            within ".edit_proposal" do
              fill_in :proposal_title, with: "Proposal with attachments"
              fill_in :proposal_body, with: "This is my proposal and I want to upload attachments."
              find("*[type=submit]").click
            end

            expect(page).to have_no_content("Attach images")

            click_button "Publish"

            expect(page).to have_content("successfully")
          end
        end
      end
    end
  end
end

def complete_proposal_path(component, proposal)
  Decidim::EngineRouter.main_proxy(component).proposal_path(proposal) + "/complete"
end
