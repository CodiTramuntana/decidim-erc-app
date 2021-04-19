# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/proposals/admin/proposals/_bulk-actions",
                     name: "add_amendment_exportations_to_proposal",
                     insert_before: "erb[loud]:contains('new_proposals_import_path')",
                     text: "<%= link_to t('actions.export_amendments', scope: 'decidim'),
                        Rails.application.routes.url_helpers.amendment_exports_path(params[:participatory_process_slug],
                        params[:component_id]), method: :post, class: 'button tiny button--simple' %>

                      ")
