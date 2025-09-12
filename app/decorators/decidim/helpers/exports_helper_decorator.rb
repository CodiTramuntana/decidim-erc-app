# frozen_string_literal: true

module Decidim::Helpers::ExportsHelperDecorator
  def self.decorate
    Decidim::Admin::ExportsHelper.class_eval do
      def export_amendments_dropdown(scopes = Decidim::Scope.all)
        render partial: "decidim/admin/exports/amendments_dropdown", locals: { scopes: }
      end
    end
  end
end

::Decidim::Helpers::ExportsHelperDecorator.decorate
