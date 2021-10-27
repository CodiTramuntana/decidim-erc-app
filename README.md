# DECIDIM-ERC-APP

This is a Decidim ERC app.

## Overrides

### Confirmation instructions
Email content is overriden here: `app/views/devise/mailer/confirmation_instructions.html.erb`.

### Devise
Appart form the mailer content customization, there are some other `devise` related customizations in:
- `app/views/decidim/devise/sessions/new.html.erb`

### Filtering visibility
To restrict what a participant can see ERC uses scopes to associate users to geographical zones.

### User related customizations
User is overriden in `app/decorators/user_presenter_decorator.rb` which anonimizes the user name by returning the nickname instead.

Also, `can_be_contacted?` is overriden so that conversations are disalbed.

Only admins can view the links to "Edit profile" and "Create group". This is managed here: `app/decorators/decidim/cells/profile_cell_decorator.rb`.

#### User profile
Search engine don't search users.
- User profile view has been made readonly: `app/views/decidim/account/show.html.erb`.
- User can not modify its telephone number: `app/views/decidim/_user_scope.html.erb`
- User's interests page is disabled: `app/controllers/decidim/user_interests_controller.rb`.
- User's `ConversationsController` now raises a not found: `app/controllers/decidim/messaging/conversations_controller.rb`.

#### Managing user's phone number
Check the form decorators in `app/decorators/decidim/amendable`.

### Proposals
There is logic to prevent endorsing a proposal for special cases related to the ERC app customizations. This can be found in the `app/decorators/decidim/proposals/endorse_proposal_decorator.rb`.

The logic to handle when to show the endorsements button for and which endorsement identities this button can show when clicked can be found in `app/decorators/decidim/proposals/proposal_endorsements_helper_decorator.rb`.

Also the nickname field is added to serialized proposals. Find the source here: `app/decorators/decidim/proposals/proposal_serializer_decorator.rb`.

### Amendments
Amendments and users both have a scope attribute.
Only amendments in the same scope as the current user are shown.

Amendments are automatically setted with the phone number of the amender user retrieved from the CiviCrm connectivity. This phone number is visible for participants but can only be modified via CRM, check the [PR](https://github.com/CodiTramuntana/decidim-erc-app/pull/7/files).

Users can only support amendments from the same scope as them.

In `app/extensions/decidim/proposals/proposal.rb`, the following methods have been modified to handle an additional component step setting amendments_visibility option. With the methods:
- ::only_visible_emendations_for(user, component)
- ::amendables_and_visible_emendations_for(user, component)
- #visible_emendations_for(user)

The new option "scope" allows to filter emendations by the scope of the user.

Amendment view customizations:
- `app/views/decidim/proposals/proposals/_endorsements_card_row.html.erb`

### open-data is disabled
`app/assets/stylesheets/application.scss` applies css styles to hide the open-data links.
The corresponding rake task is neither scheduled.

### Authentication / Signup / Signin

This Decidim application completelly relies on [CodiTramuntana/decidim-erc-crm_authenticable](https://github.com/CodiTramuntana/decidim-erc-crm_authenticable) custom module for registration, login and verification.

This module requires an initializer: `config/initializers/decidim_erc_crm_authenticable.rb`.

## Testing

Configure the name of the test DB in you `config/application.yml` file and run:

```
RAILS_ENV=test bundle exec rails db:create
RAILS_ENV=test bundle exec rails db:migrate
```

Require missing factories in `spec/factories.rb`

Add `require "rails_helper"` to your specs and execute them from the **root directory**, i.e.:

`rspec spec/system/amend_proposal_spec.rb`
