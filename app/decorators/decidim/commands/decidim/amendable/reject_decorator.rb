# frozen_string_literal: true

Decidim::Amendable::Reject.class_eval do
  def call
    return broadcast(:invalid) if @form.invalid?

    transaction do
      reject_amendment!
      # Customization ERC
      restore_to_last_amendable_version! if last_amendable_version.present?
      # Customization ERC
      notify_emendation_state_change!
      notify_emendation_authors_and_followers
    end

    broadcast(:ok, @emendation)
  end

  private

  def restore_to_last_amendable_version!
    @amendable = Decidim.traceability.perform_action!(
      :update,
      @amendable,
      @form.emendation.creator_author,
      visibility: "public-only"
    ) do
      @amendable.title = last_amendable_version.object["title"]
      @amendable.body = last_amendable_version.object["body"]
      @amendable.save!
      @amendable
    end
    @amendable.add_coauthor(@form.emendation.creator_author, user_group: @form.emendation.creator.user_group)
  end

  def last_amendable_version
    # The first proposal version is empty because before create it not exist anything about that.
    @amendable.versions.last if @amendable.versions.size > 1
  end
end
