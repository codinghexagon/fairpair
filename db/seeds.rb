# frozen_string_literal: true

test_user_attributes = {
  email: 'test@fairpair.com',
  user_name: 'test admin',
  role: 'lead',
  password: 'password1234$',
  password_confirmation: 'password1234$'
}
# create test user
lead = User.create(test_user_attributes)
# create test project

project = lead.projects.create(name: 'Test Project')
# create developers and project sprints and adding them in project
4.times do |index|
  developer = lead.subordinates.create(email: "test#{index}@fairpair.com", user_name: "test #{index}", role: 'developer')
  project.sprints.new(name: "FP-sprint-#{index}").save
  project.user_projects.create(user_id: developer.id)
end
