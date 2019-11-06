# frozen_string_literal: true

# Disables user's interests page.
class Decidim::UserInterestsController < Decidim::ApplicationController
  before_action raise ActionController::RoutingError, "Not Found"
end
