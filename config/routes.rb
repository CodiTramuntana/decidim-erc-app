# frozen_string_literal: true

Rails.application.routes.draw do
  mount Decidim::Core::Engine => "/"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "admin/participatory_processes/:participatory_process_slug/components/:component_id/manage/amendment_exports(/:scope_id)",
       to: "decidim/admin/amendment_exports#export", as: "amendment_exports"
  delete "admin/officializations/:user_id/destroy_participant", to: "decidim/admin/officializations#destroy_participant", as: "admin_destroy_participant"
end
