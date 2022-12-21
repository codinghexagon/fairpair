# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    user_name { Faker::Name.unique.name }
    password { Faker::Internet.password }
    role { 1 }
  end
end
