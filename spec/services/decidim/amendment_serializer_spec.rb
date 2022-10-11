# frozen_string_literal: true

require "rails_helper"

module Decidim
  describe AmendmentSerializer do
    let!(:component) { create(:proposal_component) }
    let!(:amendable) { create(:proposal, component: component) }
    let!(:emendation) { create(:proposal, :unpublished, component: component) }
    let!(:amendment) { create(:amendment, amendable: amendable, emendation: emendation) }

    describe "#serialize" do
      let(:subject) { described_class.new(amendment).serialize }

      context "when export an amendment" do
        it "render id" do
          expect(subject).to include(id: emendation.id)
        end

        it "render original and new titles" do
          expect(subject).to include(original_title: amendable.title)
          expect(subject).to include(new_title: emendation.title)
        end

        it "render old and new bodies" do
          expect(subject).to include(old_body: amendable.body)
          expect(subject).to include(new_body: emendation.body)
        end
      end
    end
  end
end
