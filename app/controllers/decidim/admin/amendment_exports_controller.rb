# frozen_string_literal: true

module Decidim
  module Admin
    class AmendmentExportsController < Decidim::Admin::ApplicationController
      include Decidim::ComponentPathHelper

      FILENAME = "amendments"

      def export
        @export_data = Decidim::Exporters::AmendmentExcel.new

        add_amendments_sheet
        add_users_sheet
        add_coauthors_sheet

        # deliver_later not work with this export_data type because is not compatible.
        # export_data is calculate inside a job
        Decidim::ExportMailer.export(current_user, FILENAME, @export_data.export).deliver_now

        flash[:notice] = t("decidim.admin.exports.notice")

        redirect_back(fallback_location: manage_component_path(component))
      end

      private

      def add_amendments_sheet
        collection = Decidim::Amendment.where(decidim_emendation_id: amendments.ids)
        serializer = Decidim::AmendmentSerializer

        @export_data.add_new_sheet!(collection, serializer, name: "Amendments") do |sheet|
          old_body_format = Spreadsheet::Format.new(color: :red)
          new_body_format = Spreadsheet::Format.new(color: :green)

          sheet.column(1).default_format = old_body_format
          sheet.column(2).default_format = new_body_format
        end
      end

      def add_users_sheet
        collection = Decidim::Amendment.where(decidim_emendation_id: amendments.ids).order(:decidim_user_id)
        serializer = Decidim::AmendmentSerializer

        @export_data.add_new_sheet!(collection, serializer, name: "Users")
      end

      def add_coauthors_sheet
        collection = coauthorships
        serializer = Decidim::AmendmentCoauthorshipSerializer

        @export_data.add_new_sheet!(collection, serializer, name: "Authors")
      end

      def amendments
        @amendments ||= Decidim::Proposals::Proposal.joins(
          "INNER JOIN decidim_amendments ON decidim_amendable_type = 'Decidim::Proposals::Proposal'
          AND decidim_emendation_id = decidim_proposals_proposals.id"
        ).where("decidim_component_id = ?", params[:component_id])

        @amendments = if params[:scope_id].present?
                        @amendments.where(scope: params[:scope_id])
                      else
                        @amendments
                      end
      end

      def component
        @component ||= current_participatory_space.components.find(params[:component_id])
      end

      def current_participatory_space
        @current_participatory_space ||= Decidim::ParticipatoryProcess.find_by(slug: params[:participatory_process_slug])
      end

      def coauthorships
        @coauthorships ||= amendments.flat_map { |amendment| amendment.coauthorships }
      end
    end
  end
end
