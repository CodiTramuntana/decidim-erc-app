# frozen_string_literal: true

# # config/named_routes_overrides.rb
# Rails.application.routes.draw do
#   # put your named routes here, which you also included in config/routes.rb
#   processes_name_url = :forums.to_s
#
#     get "#{processes_name_url}/:process_id", to: redirect { |params, _request|
#       process = Decidim::ParticipatoryProcess.find(params[:process_id])
#       process ? "/#{processes_name_url}/#{process.slug}" : "/404"
#     }, constraints: { process_id: /[0-9]+/ }, controller: "decidim/participatory_processes/participatory_processes"
#
#     get "/#{processes_name_url}/:process_id/f/:component_id", to: redirect { |params, _request|
#       process = Decidim::ParticipatoryProcess.find(params[:process_id])
#       process ? "/#{processes_name_url}/#{process.slug}/f/#{params[:component_id]}" : "/404"
#     }, constraints: { process_id: /[0-9]+/ }, controller: "decidim/participatory_processes/participatory_processes"
#
#     resources :participatory_process_groups, only: :show, path: "forums_group", controller: "decidim/participatory_processes/participatory_process_groups"
#     resources :participatory_processes, only: [:index, :show], param: :slug, path: "forums", controller: "decidim/participatory_processes/participatory_processes" do
#       resources :participatory_process_steps, only: [:index], path: "steps", controller: "decidim/participatory_processes/participatory_process_steps"
#       resource :participatory_process_widget, only: :show, path: "embed", controller: "decidim/participatory_processes/participatory_process_widgets"
#     end
#
#     scope "/#{processes_name_url}/:participatory_process_slug/f/:component_id" do
#       Decidim.component_manifests.each do |manifest|
#         next unless manifest.engine
#
#         constraints Decidim::CurrentComponent.new(manifest) do
#           mount manifest.engine, at: "/", as: "decidim_participatory_process_#{manifest.name}"
#         end
#       end
#     end
# end
