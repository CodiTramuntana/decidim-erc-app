# frozen_string_literal: true

module Decidim
  class AmendmentUserSerializer < Decidim::Exporters::Serializer
    include Decidim::ResourceHelper
    include Decidim::TranslationsHelper

    # Public: Initializes the serializer with a result.
    def initialize(result)
      @result = result
    end

    # Public: Exports a hash with the serialized data for this result.
    def serialize
      {
        id: @result.id
      }
    end

    private

  end
end
