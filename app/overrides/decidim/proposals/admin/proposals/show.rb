# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/admin/proposals/show",
                     name: "change_nickname_by_name_in_show_proposal",
                     replace: "erb[loud]:contains('coauthor_presenters_for(proposal).each do |presented_author|')",
                     text: "

      <% coauthor_presenters_for(proposal).each do |presented_author| %>
      <li class='component__show_nav-author-title'>
        <%= link_to_if(
            presented_author.profile_path.present?,
            presented_author.class == Decidim::UserPresenter ? presented_author.full_name : presented_author.name,
            presented_author.profile_path,
            target: :blank
            ) %>
        <% if presented_author.can_be_contacted? && presented_author.nickname != present(current_user).nickname %>
          <%= link_to_if(
            presented_author.profile_path.present?,
            presented_author.class == Decidim::UserPresenter ? presented_author.full_name : presented_author.name,
            presented_author.profile_path,
            target: :blank
            ) %>
        <% end %>
      </li>
    <% end %>
  ",
                     original: "")
