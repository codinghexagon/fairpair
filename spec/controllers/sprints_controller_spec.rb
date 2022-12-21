require 'rails_helper'

RSpec.describe SprintsController, type: :controller do
  let!(:project_lead) { create(:user, role: 0) }
  let!(:project) { create(:project) }
  let!(:sprint) { create(:sprint) }

  before do
    sign_in(project_lead)
  end

  describe 'GET /index' do
    it 'Deletes all sprints when 0 sprints is set' do
      expect do
        get :index, params: { project_id: project.id, sprints: 0 }
      end.to change(Sprint, :count).by(-1)
    end

    it 'Does not effect the sprints when they are given with existing count' do
      expect do
        get :index, params: { project_id: project.id, sprints: 1 }
      end.to change(Sprint, :count).by(0)
    end

    it 'Create project sprints with given count' do
      expect do
        get :index, params: { project_id: project.id, sprints: 2 }
      end.to change(Sprint, :count).by(2)
    end
  end

  describe 'POST /create' do
    it 'Redirects to project path with successful rsponce' do
      get :create, params: { project_id: project.id, sprints: 0 }

      expect(response).to redirect_to(project_path(project))
    end

    it 'Does not effect the sprints when they are given with existing count' do
      expect do
        get :index, params: { project_id: project.id, sprints: 1 }
      end.to change(Sprint, :count).by(0)
    end

    it 'Does not effect the sprints with empty sprints attributes' do
      expect do
        get :index, params: { project_id: project.id, sprints: '' }
      end.to change(Sprint, :count).by(0)
    end

    it 'Create project sprints with given count' do
      expect do
        get :index, params: { project_id: project.id, sprints: 2 }
      end.to change(Sprint, :count).by(2)
    end
  end
end
