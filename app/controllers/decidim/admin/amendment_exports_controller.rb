# frozen_string_literal: true

module Decidim
  module Admin
    class AmendmentExportsController < Decidim::Admin::ApplicationController
      include Decidim::ComponentPathHelper

      NAME = "amendments"

      def export
        export_data = Decidim::Exporters::AmendmentExcel.new

        add_amendments!(export_data)
        add_users!(export_data)

        Decidim::ExportMailer.export(current_user, NAME, export_data.export).deliver_now

        flash[:notice] = t("decidim.admin.exports.notice")

        redirect_back(fallback_location: manage_component_path(component))
      end

      private

      def add_amendments!(export_data)
        proposal_ids = Decidim::Proposals::Proposal.where(decidim_component_id: params[:component_id]).ids
        collection = Decidim::Amendment.where(decidim_amendable_id: proposal_ids)
        serializer = Decidim::AmendmentSerializer

        export_data.add_new_sheet!(collection, serializer, :name => "Test") do |sheet|
          old_body_format = Spreadsheet::Format.new(
            color: :red
          )
          new_body_format = Spreadsheet::Format.new(
            color: :green
          )
          sheet.column(2).default_format = old_body_format
          sheet.column(3).default_format = new_body_format
        end
      end

      def add_users!(export_data)
        export_data.add_new_sheet!(Decidim::User.all, Decidim::AmendmentUserSerializer, name: "Users")
      end

      def component
        @component ||= current_participatory_space.components.find(params[:component_id])
      end

      def current_participatory_space
        @current_participatory_space ||= Decidim::ParticipatoryProcess.find_by(slug: params[:participatory_process_slug])
      end
    end
  end
end
