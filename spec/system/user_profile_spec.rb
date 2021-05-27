# frozen_string_literal: true

require "rails_helper"

describe "Profile", type: :system do
  let(:user) { create(:user, :confirmed, admin: admin) }

  before do
    switch_to_host(user.organization.host)
  end

  context "when visiting own user profile" do
    before do
      login_as user, scope: :user
      visit decidim.root_path
      within_user_menu do
        find("a", text: "profile").click
      end
    end

    context "and user is admin" do
      let(:admin) { true }

      it "adds a link to edit the profile" do
        expect(page).to have_link("Edit profile")
      end

      it "adds a link to create a group" do
        expect(page).to have_link("Create group")
      end
    end

    context "and user is NOT admin" do
      let(:admin) { false }

      it "does NOT add a link to edit the profile" do
        expect(page).not_to have_link("Edit profile")
      end

      it "does NOT add a link to create a group" do
        expect(page).not_to have_link("Create group")
      end
    end
  end

  context "when visiting a user profile" do
    let(:admin) { false }

    before { visit decidim.profile_path(user.nickname) }

    it "shows the user's scope name" do
      expect(page).to have_content(user.scope.name)
    end
  end
end
