# frozen_string_literal: true

module Decidim
  module Erc
    module CrmAuthenticable
      filepath = Rails.root.join("config", "civi_crm", "local_comarcal_relationships.yml")
      SCOPE_CODES = YAML.load_file(filepath)
    end
  end
end
