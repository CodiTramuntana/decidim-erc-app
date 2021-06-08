# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/admin/proposals/_bulk-actions",
                     name: "add_amendment_exportations_to_proposal",
                     insert_before: "erb[loud]:contains('new_proposals_import_path')",
                     text: "<%= export_amendments_dropdown %>",
                     original: '73e9d0771125e8dc2d7655f303cbbcff375c18a6')
