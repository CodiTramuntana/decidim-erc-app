# frozen_string_literal: true

# This controller is overwritting the functionality of conversations for ERC.
# Remove if they want to enable again.
module Decidim
  module Messaging
    class ConversationsController < Decidim::ApplicationController
      before_action :redirect_to_not_found

      private

      def redirect_to_not_found
        raise ActionController::RoutingError, "Not Found"
      end
    end
  end
end
