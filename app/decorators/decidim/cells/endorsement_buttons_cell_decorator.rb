# frozen_string_literal: true

# This decorator adds logic to handle when to show the endorsements button for.
Decidim::EndorsementButtonsCell.class_eval do
  # Method overrided.
  # Add guard clause for emendations: don't show the endorsement button if
  # the user is not a manager of a grup or has a different scope than the resource.
  def render_endorsements_button
    return if resource.emendation? && (manageable_user_groups.empty? || resource.scope != current_user.scope)

    if endorsements_blocked_or_user_can_not_participate?
      render_disabled_endorsements_button
    elsif !current_user
      render_user_login_button
    elsif current_user_and_allowed?
      # Remove identities_cabin
      if user_has_verified_groups?
        render "select_identity_button"
      else
        render_user_identity_endorse_button
      end
    else # has current_user but is not allowed
      render_verification_modal
    end
  end

  # Method overrided.
  # Add guard clause for emendations: don't show the endorsement button if
  # the user is not a manager of a grup or has a different scope than the resource.
  def render_endorsements_count
    return if resource.emendation? && (manageable_user_groups.empty? || resource.scope != current_user.scope)

    content = icon("bullhorn", class: "icon--small", aria_label: t("decidim.endorsable.endorsements_count"), role: "img")
    content += resource.endorsements_count.to_s
    html_class = "button small compact button--shadow secondary"
    html_class += " active" if fully_endorsed?(resource, current_user)
    tag_params = { id: "resource-#{resource.id}-endorsements-count", class: html_class }
    if resource.endorsements_count.positive?
      link_to "#list-of-endorsements", tag_params do
        content
      end
    else
      content_tag(:div, tag_params) do
        content
      end
    end
  end
end
