require "ffaker"

FactoryGirl.define do
  factory :part_one_movie do
    sequence :video_id do |n|
      "sm#{n}"
    end
  end

  factory :mylist do
    sequence(:mylist_id)
    creator Faker::Name.name
    title Faker::Movie.title
    url Faker::Internet.uri('http')
    created_at Time.now
    updated_at Time.now
  end

  factory :movie do
    sequence(:video_id) {|n| "sm{n}" }
  end

  factory :mylist_movie do
    mylist
    movie
  end
end
