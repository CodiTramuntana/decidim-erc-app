# frozen_string_literal: true

Decidim::AmendmentsHelper.class_eval do
  # Method overrided.
  # Add amendment_type in amendments fields.
  def amendments_form_field_for(attribute, form, original_resource)
    options = {
      class: "js-hashtags",
      label: amendments_form_fields_label(attribute),
      value: amendments_form_fields_value(original_resource, attribute)
    }

    case attribute
    when :title
      form.text_field(:title, options)
    when :body
      text_editor_for(form, :body, options.merge(hashtaggable: true))
    when :amendment_type
      values = [
        { name: t("decidim.amendments.types.add"), key: "add" },
        { name: t("decidim.amendments.types.remove"), key: "remove" },
        { name: t("decidim.amendments.types.modify"), key: "modify" }
      ]
      form.select(:amendment_type,
                  values.map { |g| [g[:name], g[:key]] },
                  label: t("decidim.amendments.type"))
    end
  end
end
