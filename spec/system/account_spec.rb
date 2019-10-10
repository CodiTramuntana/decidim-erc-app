# frozen_string_literal: true

require "rails_helper"

describe "Account", type: :system do
  let(:user) { create(:user, :confirmed, password: password, password_confirmation: password) }
  let(:password) { "dqCFgjfDbC7dPbrv" }
  let(:organization) { user.organization }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when on the account page" do
    before do
      visit decidim.account_path
    end

    it "does not allow to edit personal data" do
      expect(page).to have_field(:user_name, readonly: true)
      expect(page).to have_field(:user_nickname, readonly: true)
      expect(page).to have_field(:user_email, readonly: true)
    end
  end
end
