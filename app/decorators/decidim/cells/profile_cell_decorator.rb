# frozen_string_literal: true

# This decorator handles when to show some links on the profile sidebar.
module Decidim::Cells::ProfileCellDecorator
  def self.decorate
    Decidim::ProfileCell.class_eval do
      # Method overrided.
      # Only admins can view the links to "Edit profile" and "Create group".
      def own_profile?
        current_user&.admin? && current_user == profile_holder
      end
    end
  end
end

::Decidim::Cells::ProfileCellDecorator
