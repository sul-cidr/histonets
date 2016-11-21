# frozen_string_literal: true

FactoryGirl.define do
  factory :image do
    sequence :file_name do |n|
      "eddie#{n}.jpg"
    end

    factory :image_with_collections do
      transient do
        collections_count 3
      end
      after(:create) do |image, evaluator|
        create_list(:collection, evaluator.collections_count, images: [image])
      end
    end
  end
end
