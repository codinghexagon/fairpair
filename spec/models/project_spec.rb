# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Project Model tests' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user_id) }

    context 'validations' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }
    end

    context 'associations' do
      it { should have_many(:user_projects) }
      it { should have_many(:users).through(:user_projects) }
      it { should have_many(:sprints) }
    end

    context 'scopes' do
      let(:testProject) { create(:project) }

      it 'should return projects in descending order' do
        expect(Project.id_ordered_desc).to include(testProject)
      end
    end

    context 'methods' do
      let(:testUser) { create(:user) }

      it 'should return developer ids for the project' do
        test_user = user.subordinates << testUser
        test_project = user.projects.create(name: 'test_project')
        test_project.user_projects.create(user: testUser)

        expect(test_project.project_developer_ids(user).last).to eq(testUser.id)
      end
    end
  end
end 
