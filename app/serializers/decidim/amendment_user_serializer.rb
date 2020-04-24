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
        id: @result.id,
        name: amendment_user.name
      }
    end

    private

    def amendment_user
      @amendment_user ||= Decidim::User.find(@result.decidim_user_id)
    end
  end
end
