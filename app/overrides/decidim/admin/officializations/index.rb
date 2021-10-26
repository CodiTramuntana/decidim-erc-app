# frozen_string_literal: true

Deface::Override.new(virtual_path: +"decidim/admin/officializations/index",
                     name: "add_remove_icon_to_officializations_index",
                     insert_after: "erb[loud]:contains('current_or_new_conversation_path_with(user)')",
                     text: "
                      <%= icon_link_to 'circle-x', decidim.account_path(delete_reason: 'remove_user_by_admin', user: user), t('.remove_user'),
                        class: 'action-icon--remove', method: :delete, data: { confirm: t('actions.confirm_destroy', scope: 'decidim.admin') } %>
                     ",
                     original: "14c9654d41f9a027ee33dc53a00f3c9ef7d44f30")
