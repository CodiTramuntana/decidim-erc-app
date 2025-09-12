# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/admin/proposals/_proposal-tr",
                     name: "add_author_text_to_column_index_proposals",
                     insert_after: "tr td:nth-child(3)",
                     text: "
    <td>
      <%= Decidim::Proposals::ProposalPresenter.new(proposal).author.name %>
    </td>
   ",
                     original: "7cfebc79f4240f348a72976c718e76537c3c45c8")
