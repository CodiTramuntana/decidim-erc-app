# DECIDIM-ERC-APP

This is a Decidim ERC app.

## Testing

Run `rake decidim:generate_external_test_app` to generate a dummy application.

Require missing factories in `spec/factories.rb`

Add `require "rails_helper"` to your specs and execute them from the **root directory**, i.e.:

`rspec spec/system/amend_proposal_spec.rb`
