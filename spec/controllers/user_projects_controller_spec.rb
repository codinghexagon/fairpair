require 'rails_helper'

RSpec.describe UserProjectsController, type: :controller do
  let!(:project_lead) { create(:user, role: 0) }
  let!(:developer) { create(:user, role: 1, lead_id: project_lead.id) }
  let!(:project) { create(:project) }

  before do
    sign_in(project_lead)
    project.users.push([project_lead, developer])
  end

  describe 'DELETE /destroy' do
    it 'Destroys the requested project with notice' do
      delete :destroy, params: { developer_id: developer.id, project_id: project.id }

      expect(flash[:notice]).to eql('Project was successfully destroyed.')
    end

    it 'Redirects to project path ' do
      delete :destroy, params: { developer_id: developer.id, project_id: project.id }

      expect(response).to redirect_to(project_path(project.id))
    end
  end
end
