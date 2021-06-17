# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/admin/proposals/show",
                     name: "change_nickname_by_name_in_show_proposal",
                     replace: "erb[loud]:contains('presented_author.profile_path.present?')",
                     text: "
    <%= link_to_if(
      presented_author.profile_path.present?,
      presented_author.class == Decidim::UserPresenter ? presented_author.full_name : presented_author.name,
      presented_author.profile_path,
      target: :blank
      )
    %>
  ",
                     original: "6f6d20163faa27a98348eabe294b221c15ce162f")
