# frozen_string_literal: true

module Decidim
  class AmendmentSerializer < Decidim::Exporters::Serializer
    include Decidim::ResourceHelper
    include Decidim::TranslationsHelper

    # Public: Initializes the serializer with a result.
    def initialize(result)
      @result = result
    end

    # Public: Exports a hash with the serialized data for this result.
    def serialize
      {
        id: @result.id,
        title: amendment.title,
        old_body: amendment.body,
        new_body: amendable_type.find(@result.decidim_emendation_id).body,
        user_name: amendment_user&.name,
        scope: amendment_user.try(:scope)&.name
      }
    end

    private

    def amendable_type
      @amendable_type ||= @result.decidim_amendable_type.constantize
    end

    def amendment_user
      @amendment_user ||= Decidim::User.find(@result.decidim_user_id)
    end

    def amendment
      @amendment ||= amendable_type.find(@result.decidim_amendable_id)
    end
  end
end
