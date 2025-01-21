# frozen_string_literal: true
Deface::Override.new(virtual_path: +"decidim/admin/officializations/index",
                     name: "add_remove_icon_to_officializations_index",
                     insert_after: "erb[loud]:contains('current_or_new_conversation_path_with(user)')",
                     text: "
                      <%= icon_link_to 'close-circle-line', Rails.application.routes.url_helpers.admin_destroy_participant_path(delete_reason: 'remove_user_by_admin',
                        user_id: user.id), t('.remove_user'), class: 'action-icon--remove', method: :delete,
                        data: { confirm: t('actions.confirm_destroy', scope: 'decidim.admin') } %>
                     ",
                     original: "f7c8016981bdcec511938b2f5ed05236ab1430d6")
