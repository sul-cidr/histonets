# frozen_string_literal: true

FactoryGirl.define do
  factory :collection_template do
    collection
    factory :collection_template_with_image do
      image
    end
  end
end
