# frozen_string_literal: true

# This decorator adds the nickname field to serialized proposals.
# We are calling the original method and then tapping into it in order
# to mutate the return value. See: https://stackoverflow.com/a/4471202
Decidim::Proposals::ProposalSerializer.class_eval do
  alias_method :original_serialize, :serialize

  def serialize
    original_serialize.tap do |hsh|
      hsh.merge!(nickname: proposal.creator_author.try(:nickname))
    end
  end
end
