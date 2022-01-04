# frozen_string_literal: true

Decidim::Proposals::Proposal.class_eval do
  enum sectorial_commission: [
    :territorial_congress,
    :economic_financial_policy,
    :agriculture_livestock_fishing,
    :company_industry_services,
    :commerce_tourism_consumption,
    :universities_search_innovation,
    :information_society,
    :work_self_employment_social_economy,
    :union_forum,
    :aapp,
    :justice,
    :social_movements,
    :lgtbi,
    :citizenship,
    :social_rights,
    :health,
    :sports,
    :education,
    :culture,
    :linguistic_politic,
    :audiovisual_communication,
    :memory_repair,
    :environment_energy,
    :territorial_policy,
    :security_civil_protection,
    :european_union_internatinal_politics,
    :peace_solidarity_cooperation
  ]

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end
end
