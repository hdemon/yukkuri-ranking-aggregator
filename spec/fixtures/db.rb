FactoryGirl.define do
  factory :part_one_movie do
    sequence :video_id do |n|
      "sm#{n}"
    end
  end
end
