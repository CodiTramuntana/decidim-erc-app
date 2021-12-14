# frozen_string_literal: true

require "rails_helper"

module Decidim
  describe InviteUser do
    let(:organization) { create(:organization) }
    let!(:admin) { create(:user, :confirmed, :admin, organization: organization) }
    let!(:scope) { create(:scope, organization: organization, code: "1") }
    let(:form) do
      Decidim::InviteUserForm.from_params(
        name: "Old man",
        email: "oldman@email.com",
        organization: organization,
        role: "admin",
        invited_by: admin,
        invitation_instructions: "invite_admin"
      )
    end
    let!(:command) { described_class.new(form) }
    let(:invited_user) { User.where(organization: organization).last }

    context "when a user does not exist for the given email" do
      it "creates it with scope" do
        expect do
          command.call
        end.to change(User, :count).by(1)

        expect(invited_user.email).to eq(form.email)
        expect(Decidim::User.last.scope.code).to eq(scope.code)
      end

      it "broadcasts ok and the user" do
        expect do
          command.call
        end.to broadcast(:ok)
      end
    end
  end
end
