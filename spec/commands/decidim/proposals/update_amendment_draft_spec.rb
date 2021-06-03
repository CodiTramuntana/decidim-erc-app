# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Amendable
    describe UpdateDraft do
      let!(:component) { create(:proposal_component) }
      let!(:other_user) { create(:user, :confirmed, organization: component.organization) }

      let!(:amendable) { create(:proposal, component: component) }
      let!(:emendation) { create(:proposal, :unpublished, component: component) }
      let!(:amendment) { create(:amendment, :draft, amendable: amendable, emendation: emendation) }

      let(:title) { "More sidewalks and less roads!" }
      let(:body) { "Everything would be better" }
      let(:amendment_type) { "add" }
      let(:params) do
        {
          id: amendment.id,
          emendation_params: { title: title, body: body, amendment_type: amendment_type }
        }
      end

      let(:current_user) { amendment.amender }
      let(:context) do
        {
          current_user: current_user,
          current_organization: component.organization
        }
      end

      let(:form) { Decidim::Amendable::EditForm.from_params(params).with_context(context) }
      let(:command) { described_class.new(form) }

      describe "when the form is valid" do
        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end
    
        it "updates the emendation without creating a PaperTrail version" do
          expect { command.call }
            .to change(form.emendation, :title)
            .and change(form.emendation, :body)
            .and change(form.emendation, :amendment_type)
          expect(amendable.class.last.versions.count).to eq(0)
        end
      end
    
      describe "when the current user is not the amender" do
        let(:current_user) { other_user }
    
        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end
      end
    
      describe "when the amendment is not a draft" do
        before do
          amendment.update(state: "evaluating")
        end
    
        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end
      end
    end
  end
end
