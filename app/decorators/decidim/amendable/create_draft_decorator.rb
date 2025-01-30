# frozen_string_literal: true

module Decidim::Amendable::CreateDraftDecorator
  def self.decorate
    Decidim::Amendable::CreateDraft.class_eval do
      # Method overrided.
      # Add amendment_type and sectorial_commission to an emendation
      def create_emendation!
        transaction do
          PaperTrail.request(enabled: false) do
            @emendation = Decidim.traceability.perform_action!(
              :create,
              amendable.class,
              current_user,
              visibility: "public-only"
            ) do
              emendation = amendable.class.new(form.emendation_params)
              emendation.title = { I18n.locale => form.emendation_params.with_indifferent_access[:title] }
              emendation.body = { I18n.locale => form.emendation_params.with_indifferent_access[:body] }
              emendation.amendment_type = form.amendment_type
              emendation.sectorial_commission = form.sectorial_commission
              emendation.component = amendable.component
              emendation.add_author(current_user, user_group)
              emendation.decidim_scope_id = form.decidim_scope_id
              emendation.save!
              emendation
            end
          end

          create_proposal_note(@emendation)
        end
      end

      private

      # Method added.
      # Creates a ProposalNote with the phone number.
      def create_proposal_note(emendation)
        Decidim::Proposals::ProposalNote.find_or_create_by(
          proposal: emendation,
          author: current_user,
          body: form.phone_number.to_s
        )
      end
    end
  end
end

::Decidim::Amendable::CreateDraftDecorator.decorate
