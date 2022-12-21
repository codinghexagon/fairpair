# frozen_string_literal: true

FactoryBot.define do
  factory :sprint do
    name { Faker::Name.unique.name }
    project_id { Project.first.id }
  end
end
