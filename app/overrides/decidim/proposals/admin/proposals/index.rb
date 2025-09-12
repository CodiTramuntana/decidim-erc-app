# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/admin/proposals/index",
                     name: "add_author_column_to_index_proposals",
                     insert_after: "table th:nth-child(3)",
                     text: "
    <th>
      <%= sort_link(query, :author, t('models.proposal.fields.author', scope: 'decidim.proposals')) %>
    </th>
  ",
                     original: "7b69af0098b5efc51731264f854cd8cad873ba0c")
