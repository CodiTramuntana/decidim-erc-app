# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/admin/proposals/_proposal-tr",
                     name: "add_author_text_to_column_index_proposals",
                     insert_after: "tr td:nth-child(3)",
                     text: "
    <td>
      <%= Decidim::Proposals::ProposalPresenter.new(proposal).author.name %>
    </td>
   ",
                     original: "3378e0a93910eedab971f2b7cee1bcdc68920de5")
