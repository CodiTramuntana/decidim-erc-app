# frozen_string_literal: true

module Decidim::Proposals::ProposalDecorator
  def self.decorate
    Decidim::Proposals::Proposal.class_eval do
      enum sectorial_commission: {
        territorial_congress: 0,
        public_administrations: 1,
        agriculture_livestock_fishing: 2,
        citizenship: 3,
        commerce_tourism_consumption: 3,
        peace_solidarity_cooperation: 5,
        audiovisual_communication: 6,
        culture: 7,
        animal_rights: 8,
        social_rights: 9,
        education: 10,
        company_industry_services: 11,
        sports: 12,
        union_forum: 13,
        justice: 14,
        memory: 15,
        environment_energy: 16,
        social_movements: 17,
        economic_financial_policy: 18,
        linguistic_politic: 19,
        territorial_policy: 20,
        health: 21,
        security_civil_protection: 22,
        information_society: 23,
        work_self_employment_social_economy: 24,
        european_union_internatinal_politics: 25,
        universities_search_innovation: 26,
        lgtbi: 27
      }

      def self.human_enum_name(enum_name, enum_value)
        I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
      end
    end
  end
end

# This condition fix an error with a FixReferenceForAllResources migration
::Decidim::Proposals::ProposalDecorator.decorate if ActiveRecord::Base.connection.table_exists? "decidim_proposals_proposals"
