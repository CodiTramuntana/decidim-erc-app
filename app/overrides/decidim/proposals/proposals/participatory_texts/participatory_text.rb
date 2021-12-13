# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/proposals/proposals/participatory_texts/participatory_text",
                     name: "add_scope_filter_to_participatory_texts",
                     insert_after: "erb[loud]:contains('decidim/proposals/proposals/participatory_texts/view_index')",
                     text: "
                      <%= render partial: 'decidim/proposals/proposals/participatory_texts/view_scope' %>
                     ")
