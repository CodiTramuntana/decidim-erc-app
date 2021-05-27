# frozen_string_literal: true

Decidim::UserPresenter.class_eval do
  def name
    __getobj__.nickname
  end

  def full_name
    __getobj__.name
  end

  def can_be_contacted?
    false
  end
end
