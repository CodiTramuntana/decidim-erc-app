# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Amendable
    describe UpdateDraft do
      let!(:component) { create(:proposal_component) }
      let!(:amendable) { create(:proposal, component: component) }
      let!(:emendation) { create(:proposal, :unpublished, component: component) }
      let!(:amendment) { create(:amendment, :draft, amendable: amendable, emendation: emendation) }

      let(:title) { "More sidewalks and less roads!" }
      let(:body) { "Everything would be better" }
      let(:params) do
        {
          id: amendment.id,
          emendation_params: { title: title, body: body }
        }
      end

      let(:user) { amendment.amender }
      let(:context) do
        {
          current_user: user,
          current_organization: component.organization
        }
      end

      let(:form) { Decidim::Amendable::EditForm.from_params(params).with_context(context) }
      let(:command) { described_class.new(form) }

      describe "when the form is valid" do
        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end

        it "updates the emendation with the scope of the user" do
          emendation.update(scope: nil)

          expect { command.call }.to change(form.emendation, :scope).from(nil).to(user.scope)
        end
      end
    end
  end
end
