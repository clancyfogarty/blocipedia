FactoryBot.define do
  pw = RandomData.random_sentence

  factory :user do
    sequence(:email){|n| "user#{n}@factory.com"}
    password pw
    confirmed_at Time.now
  end
end
