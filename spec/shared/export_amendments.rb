# frozen_string_literal: true

shared_examples "export amendments" do
  let!(:amendment) { create_list(:amendment, 3, :draft, amendable: amendable, emendation: emendation) }

  it "exports all" do
    find(".exports-amendments").click
    click_link "All"

    within ".flash.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to include("amendments", "xls")
    expect(last_email.attachments.length).to be_positive
    expect(last_email.attachments.first.filename).to match(/^amendments.*\.zip$/)
  end

  it "exports only of scope" do
    find(".exports-amendments").click
    click_link "Amendments of #{translated(scope.name)}"

    within ".flash.success" do
      expect(page).to have_content("in progress")
    end

    expect(last_email.subject).to include("amendments", "xls")
    expect(last_email.attachments.length).to be_positive
    expect(last_email.attachments.first.filename).to match(/^amendments.*\.zip$/)
  end
end
