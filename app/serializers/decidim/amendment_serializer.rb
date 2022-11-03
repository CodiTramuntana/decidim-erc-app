# frozen_string_literal: true

module Decidim
  class AmendmentSerializer < Decidim::Exporters::Serializer
    include Decidim::ResourceHelper
    include Decidim::TranslationsHelper
    MAX_LENGTH = 32_767

    # Public: Initializes the serializer with a result.
    def initialize(result)
      @result = result
    end

    # Public: Exports a hash with the serialized data for this result.
    def serialize
      {
        id: emendation.id,
        original_title: amendable.title,
        new_title: emendation.title,
        old_body: amendable.body,
        new_body: new_body,
        user_name: amendment_user&.name,
        scope: amendment_user&.scope&.name,
        amendment_type: emendation.amendment_type,
        sectorial_commission: emendation.sectorial_commission,
        diff: amendment_diff,
        created_at: emendation.created_at.localtime
      }
    end

    private

    def amendable_type
      @amendable_type ||= @result.decidim_amendable_type.constantize
    end

    def amendment_user
      @amendment_user ||= Decidim::User.find_by(id: @result.decidim_user_id)
    end

    def amendable
      @amendable ||= amendable_type.find(@result.decidim_amendable_id)
    end

    def emendation
      @emendation ||= amendable_type.find(@result.decidim_emendation_id)
    end

    def new_body
      body = emendation.body

      body = body.truncate(MAX_LENGTH, escape: false) if body.length >= MAX_LENGTH

      body
    end

    def amendment_diff
      Differ.diff_by_word(new_body.to_s, amendable.body.to_s).format_as(:ascii)
    end
  end
end
