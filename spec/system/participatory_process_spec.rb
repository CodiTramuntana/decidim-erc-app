# frozen_string_literal: true

require "rails_helper"

describe "Participatory Process page", type: :system do
  let(:participatory_process) { create(:participatory_process) }
  let!(:component) { create(:component, :published, participatory_space: participatory_process, manifest_name: manifest_name) }

  before do
    switch_to_host(participatory_process.organization.host)
    visit decidim_participatory_processes.participatory_process_path(participatory_process)
    allow(Decidim).to receive(:component_manifests).and_return([component.manifest])
  end

  context "when the process has a proposals component" do
    let(:manifest_name) { :proposals }
    let!(:proposals) { create_list(:proposal, 3, component: component) }

    it "does NOT show the highlighted proposals section" do
      expect(page).not_to have_css(".highlighted_proposals")
    end
  end
end
