# frozen_string_literal: true

module Decidim
  class AmendmentCoauthorshipSerializer < Decidim::Exporters::Serializer
    include Decidim::ResourceHelper
    include Decidim::TranslationsHelper

    # Public: Initializes the serializer with a result.
    def initialize(result)
      @result = result
    end

    # Public: Exports a hash with the serialized data for this result.
    def serialize
      {
        title: amendment.title,
        body: amendment.body,
        author: coauthorship_user&.name
      }
    end

    private

    def amendable_type
      @amendable_type ||= @result.coauthorable_type.constantize
    end

    def coauthorship_user
      @coauthorship_user ||= Decidim::User.find_by(id: @result.decidim_author_id)
    end

    def amendment
      @amendment ||= amendable_type.find(@result.coauthorable_id)
    end
  end
end
