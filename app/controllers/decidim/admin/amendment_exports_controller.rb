# frozen_string_literal: true

module Decidim
  module Admin
    class AmendmentExportsController < Decidim::Admin::ApplicationController
      include Decidim::ComponentPathHelper

      def export
        collection = Decidim::Amendment.all
        serializer = Decidim::AmendmentSerializer
        user = current_user
        name = "amendments"
        format = "Excel"

        export_data = Decidim::Exporters.find_exporter(format).new(collection, serializer).export do |sheet|
          old_body_format = Spreadsheet::Format.new(
            color: :red
          )
          new_body_format = Spreadsheet::Format.new(
            color: :green
          )
          sheet.column(1).default_format = old_body_format
          sheet.column(2).default_format = new_body_format
        end

        Decidim::ExportMailer.export(user, name, export_data).deliver_now

        redirect_back(fallback_location: manage_component_path(component))
      end

      private

      def component
        @component ||= current_participatory_space.components.find(params[:component_id])
      end
    end
  end
end