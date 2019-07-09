# frozen_string_literal: true

Decidim::Proposals::ProposalEndorsementsHelper.class_eval do
  def render_endorsements_button_card_part(proposal, fully_endorsed, html_class = nil)
    return if proposal.emendation? && !current_user ||
      proposal.emendation? && manageable_user_groups.empty?

    endorse_translated = t("decidim.proposals.proposal_endorsements_helper.render_endorsements_button_card_part.endorse")
    html_class = "card__button button" if html_class.blank?
    if current_settings.endorsements_blocked? || !current_component.participatory_space.can_participate?(current_user)
      content_tag :span, endorse_translated, class: "#{html_class} #{endorsement_button_classes(false)} disabled", disabled: true, title: endorse_translated
    elsif current_user && allowed_to?(:endorse, :proposal, proposal: proposal)
      render partial: "endorsement_identities_cabin", locals: { proposal: proposal, fully_endorsed: fully_endorsed }
    elsif current_user
      button_to(endorse_translated, proposal_path(proposal),
                data: { open: "authorizationModal", "open-url": modal_path(:endorse, proposal) },
                class: "#{html_class} #{endorsement_button_classes(false)} secondary")
    else
      action_authorized_button_to :endorse, endorse_translated, "", resource: proposal, class: "#{html_class} #{endorsement_button_classes(false)} secondary"
    end
  end

  def render_endorsement_identity(proposal, user, user_group = nil)
    return if proposal.emendation? && user_group.nil?

    current_endorsement_url = proposal_proposal_endorsement_path(
      proposal_id: proposal,
      from_proposals_list: false,
      user_group_id: user_group&.id,
      authenticity_token: form_authenticity_token
    )
    presenter = if user_group
      Decidim::UserGroupPresenter.new(user_group)
    else
      Decidim::UserPresenter.new(user)
    end
    selected = proposal.endorsed_by?(user, user_group)
    http_method = selected ? :delete : :post
    render partial: "decidim/proposals/proposal_endorsements/identity", locals:
      { identity: presenter, selected: selected, current_endorsement_url: current_endorsement_url, http_method: http_method }
  end

  def manageable_user_groups
    return [] unless current_user

    @manageable_user_groups ||= Decidim::UserGroups::ManageableUserGroups.for(current_user).verified
  end

  def endorsement_buttons_column_size
    return "small-6" if @proposal.emendation? && manageable_user_groups.empty?

    "small-9"
  end

  def comment_button_column_size
    return "small-6" if @proposal.emendation? && manageable_user_groups.empty?

    "small-3"
  end
end