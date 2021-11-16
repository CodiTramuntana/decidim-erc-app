# frozen_string_literal: true

namespace :anonymize do
  task users: :environment do
    Decidim::User.where.not(admin: true).find_each do |user|
      user.update_columns(
        email: "email#{user.id}@example.org",
        name: "Anonymized User #{user.id}",
        nickname: "anon-#{user.id}",
        encrypted_password: "encryptedpassword#{user.id}",
        reset_password_token: nil,
        current_sign_in_at: nil,
        last_sign_in_at: nil,
        current_sign_in_ip: nil,
        last_sign_in_ip: nil,
        invitation_token: nil,
        confirmation_token: nil,
        unconfirmed_email: nil,
        avatar: nil
      )

      Decidim::Authorization.where(user: user).find_each do |authorization|
        authorization.update_columns(unique_id: authorization.id)
      end

      puts "Anonymizing user #{user.id}\n"
    end
  end
end
