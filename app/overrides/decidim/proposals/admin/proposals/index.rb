# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/admin/proposals/index",
  name: "add_author_column_to_index_proposals",
  insert_after: "table th:nth-child(3)",
  text: "
    <th>
      <%= sort_link(query, :author, t('models.proposal.fields.author', scope: 'decidim.proposals')) %>
    </th>
  ",
  original: '3050ec7efdccc43ad69b11a095f7dcec05a785c3')
