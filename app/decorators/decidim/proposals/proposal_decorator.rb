# frozen_string_literal: true

Decidim::Proposals::Proposal.class_eval do
  enum sectorial_commission: [
    :territorial_congress,
    :public_administrations,
    :agriculture_livestock_fishing,
    :citizenship,
    :commerce_tourism_consumption,
    :peace_solidarity_cooperation,
    :audiovisual_communication,
    :culture,
    :animal_rights,
    :social_rights,
    :education,
    :company_industry_services,
    :sports,
    :union_forum,
    :justice,
    :memory,
    :environment_energy,
    :social_movements,
    :economic_financial_policy,
    :linguistic_politic,
    :territorial_policy,
    :health,
    :security_civil_protection,
    :information_society,
    :work_self_employment_social_economy,
    :european_union_internatinal_politics,
    :universities_search_innovation,
    :lgtbi
  ]

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end
end
