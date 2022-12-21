require 'rails_helper'

RSpec.describe UserProjectsController, type: :controller do
  let!(:lead) { create(:user, role: 0) }
  let!(:developer) { create(:user, role: 1, lead_id: lead.id) }
  let!(:project) { create(:project) }

  before do
    sign_in(lead)
  end

  describe 'DELETE /destroy' do
    before do
      project.users.push([lead, developer])
    end

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
