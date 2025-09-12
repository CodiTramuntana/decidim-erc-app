# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/admin/proposals/_bulk-actions",
                     name: "add_amendment_exportations_to_proposal",
                     insert_before: "erb[loud]:contains('import_dropdown')",
                     text: "<%= export_amendments_dropdown %>",
                     original: "6583dd56d84556b0942f169816ad25cc3e0fc079")
