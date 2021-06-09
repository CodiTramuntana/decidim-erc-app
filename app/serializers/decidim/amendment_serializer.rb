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
        title: emendation.title,
        old_body: amendable.body,
        new_body: emendation.body,
        user_name: amendment_user&.name,
        scope: amendment_user&.scope&.name,
        amendment_type: amendment_type,
        diff: amendment_diff
      }
    end

    private

    def amendable_type
      @amendable_type ||= @result.decidim_amendable_type.constantize
    end

    def amendment_user
      @amendment_user ||= Decidim::User.find(@result.decidim_user_id)
    end

    def amendable
      @amendable ||= amendable_type.find(@result.decidim_amendable_id)
    end

    def emendation
      @emendation ||= amendable_type.find(@result.decidim_emendation_id)
    end

    def amendment_type
      I18n.t("decidim.amendments.types.#{emendation.amendment_type}")
    end

    def amendment_diff
      Diffy::Diff.new(
        "#{amendable.body.values.first}\n",
        "#{emendation.body.values.first}\n",
        allow_empty_diff: false,
      ).to_s(:text)
    end
  end
end
