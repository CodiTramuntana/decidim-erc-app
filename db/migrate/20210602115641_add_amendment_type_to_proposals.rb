# frozen_string_literal: true

# Add amendment_type to be able to make amendments to the proposals with this field
class AddAmendmentTypeToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_proposals_proposals, :amendment_type, :string
  end
end
