# frozen_string_literal: true

# Add sectorial_commission to be able to make amendments to the proposals with this field
class AddSectorialCommissionToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_proposals_proposals, :sectorial_commission, :string
  end
end
