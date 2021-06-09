# frozen_string_literal: true

Decidim::Admin::ExportsHelper.class_eval do
  def export_amendments_dropdown(scopes = Decidim::Scope.all)
    render partial: "decidim/admin/exports/amendments_dropdown", locals: { scopes: scopes }
  end
end
