require "ffaker"

FactoryGirl.define do
  factory :mylist do
    sequence(:mylist_id)
    creator Faker::Name.name
    title Faker::Movie.title
    url Faker::Internet.uri('http')
    created_at Time.now
    updated_at Time.now
  end
end
