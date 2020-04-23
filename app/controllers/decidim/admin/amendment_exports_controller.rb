# frozen_string_literal: true

module Decidim
  module Admin
    class AmendmentExportsController < Decidim::Admin::ApplicationController
      include Decidim::ComponentPathHelper

      NAME = "amendments"

      def export
        proposal_id = Decidim::Proposals::Proposal.find_by(decidim_component_id: params[:component_id]).id
        collection = Decidim::Amendment.where(decidim_amendable_id: proposal_id)
        serializer = Decidim::AmendmentSerializer
        user = current_user

        export_data = Decidim::Exporters::AmendmentExcel.new(collection, serializer).export do |sheet|
          old_body_format = Spreadsheet::Format.new(
            color: :red
          )
          new_body_format = Spreadsheet::Format.new(
            color: :green
          )
          sheet.column(2).default_format = old_body_format
          sheet.column(3).default_format = new_body_format
        end

        Decidim::ExportMailer.export(user, NAME, export_data).deliver_now

        flash[:notice] = t("decidim.admin.exports.notice")

        redirect_back(fallback_location: manage_component_path(component))
      end

      private

      def component
        @component ||= current_participatory_space.components.find(params[:component_id])
      end

      def current_participatory_space
        @current_participatory_space ||= Decidim::ParticipatoryProcess.find_by(slug: params[:participatory_process_slug])
      end
    end
  end
end
