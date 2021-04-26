# frozen_string_literal: true

# This decorator adds logic to which endorsement identities this button can show when clicked.
Decidim::EndorsableHelper.class_eval do
  # Method overrided.
  # Add guard clause for emendations: only show the identity partial for Decidim::UserGroup
  def render_endorsement_identity(resource, user, user_group = nil)
    return if resource.emendation? && user_group.nil?

    presenter = if user_group
                  Decidim::UserGroupPresenter.new(user_group)
                else
                  Decidim::UserPresenter.new(user)
                end

    selected = resource.endorsed_by?(user, user_group)
    http_method = selected ? :delete : :post
    render partial: "decidim/endorsements/identity", locals:
    { identity: presenter, selected: selected,
      http_method: http_method,
      create_url: path_to_create_endorsement(resource, user_group),
      destroy_url: path_to_destroy_endorsement(resource, user_group) }
  end

  # Method added.
  # Caches the result of the Rectify::Query
  def manageable_user_groups
    return [] unless current_user

    @manageable_user_groups ||= Decidim::UserGroups::ManageableUserGroups.for(current_user).verified
  end

  # Method added.
  # Returns the CSS classes used for showing only the endorsements count in the resource show page
  def endorsements_count_only_classes
    "button small compact light button--sc button--shadow expanded"
  end

  # Method added.
  # Handles the size of the div that wraps the comment button in the resource show page
  def comment_button_column_size
    return "small-6" if @resource.emendation? && manageable_user_groups.empty?

    "small-3"
  end
end
