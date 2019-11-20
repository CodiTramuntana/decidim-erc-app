# frozen_string_literal: true

# This decorator adds the nickname field to serialized proposals.
# We are calling the original method and then tapping into it in order
# to mutate the return value. See: https://stackoverflow.com/a/4471202
Decidim::Proposals::ProposalSerializer.class_eval do
  original_method = instance_method(:serialize)

  define_method(:serialize) do
    original_method.bind(self).call.tap do |hsh|
      hsh.merge!(nickname: proposal.creator_author.try(:nickname))
    end
  end
end
