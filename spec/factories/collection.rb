# frozen_string_literal: true

FactoryGirl.define do
  factory :collection do
    palette '[[255, 255, 255], [254, 254, 254]]'
    sequence(:name) { |n| "My Collection #{n}" }
    factory :collection_with_images do
      transient do
        images_count 5
      end
      after(:create) do |collection, evaluator|
        create_list(:image, evaluator.images_count, collections: [collection])
      end
    end
  end
end
