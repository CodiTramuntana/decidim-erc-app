# frozen_string_literal: true

require "rails_helper"
require "decidim/proposals/test/capybara_proposals_picker"

describe "Admin manages amendments", type: :system, serves_map: true, serves_geocoding_autocomplete: true do
  let(:manifest_name) { "proposals" }
  let!(:component) { create(:proposal_component) }
  let!(:amendable) { create(:proposal, component: component) }
  let!(:emendation) { create(:proposal, :unpublished, component: component) }
  let!(:amendment) { create(:amendment, :draft, amendable: amendable, emendation: emendation) }

  include_context "when managing a component as an admin"

  it_behaves_like "export amendments"
end
