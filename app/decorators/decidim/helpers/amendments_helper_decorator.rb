# frozen_string_literal: true

Decidim::AmendmentsHelper.class_eval do
  def amendment_types
    [
      { name: t("decidim.amendments.types.add"), key: "add" },
      { name: t("decidim.amendments.types.remove"), key: "remove" },
      { name: t("decidim.amendments.types.modify"), key: "modify" }
    ]
  end

  def sectorial_commissions
    sectorial_commissions = Decidim::Proposals::Proposal.sectorial_commissions.keys.collect do |sectorial_commission|
      [Decidim::Proposals::Proposal.human_enum_name(:sectorial_commissions, sectorial_commission), sectorial_commission]
    end
    sectorial_commissions.insert(1, ["――――――――――――――", ""])
    sectorial_commissions.insert(2, [t("decidim.amendments.sectorial_commissions"), ""])
  end
end
