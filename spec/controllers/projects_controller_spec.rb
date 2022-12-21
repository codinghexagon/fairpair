require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let!(:project_lead) { create(:user, role: 0) }
  let!(:developer) { create(:user, role: 1, lead_id: project_lead.id) }
  let!(:project) { create(:project) }
  let!(:sprint) { create(:sprint) }

  before do
    sign_in(project_lead)
    project.users.push(project_lead)
  end

  describe 'GET /index' do
    it 'Assigns all user projects as @projects' do
      get :index

      expect(assigns(:projects)).to eq([project])
    end

    it 'Responses success' do
      get :index

      expect(response.status).to eq(200)
    end
  end

  describe 'GET /show' do
    it 'renders a project#show' do
      get :show, params: { id: project.id }

      response.should render_template :show
    end

    it 'gets sprints count of the project' do
      get :show, params: { id: project.id }

      expect(assigns(:sprints)).to eq(1)
    end

    it 'Raise error beacuse of missing id' do
      expect { get :show }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'GET /new' do
    it 'Renders a successful response' do
      get :new

      expect(response.status).to eql(200)
    end

    it 'assigns a new project to @project' do
      get :new

      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'GET /edit' do
    it 'Render a successful response' do
      get :edit, params: { id: project.id }

      expect(response.status).to eql(200)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'Creates a new Project' do
        expect { post :create, params: { project: { name: 'Test Project' } } }.to change(Project, :count).by(1)
      end

      it 'Redirects to the created project' do
        post :create, params: { project: { name: 'Test Project' } }

        expect(response).to redirect_to(projects_path)
      end
    end

    context 'with invalid parameters' do
      it 'Does not create a new Project because of empty name' do
        expect { post :create, params: { project: { name: '' } } }.to change(Project, :count).by(0)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'Updates project' do
        project_name = 'Test Project'
        patch :update, params: { project: { name: project_name }, id: project.id }

        expect(project.reload.name).to eql(project_name)
      end

      it 'Redirects to the root path' do
        patch :update, params: { project: { name: 'Test Project' }, id: project.id }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'Renders edit when the project name is blank' do
        patch :update, params: { project: { name: '' }, id: project.id }

        response.should render_template("edit")
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'Destroys the requested project' do
      delete :destroy, params: { id: project.id }

      expect(flash[:notice]).to eql('Project was successfully destroyed.')
    end

    it 'Redirects to root path after project deletion' do
      delete :destroy, params: { id: project.id }

      expect(response).to redirect_to(root_path)
    end

    it 'Will not delete project because of no project id' do
      expect do
        delete :destroy
      end.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'PATCH /manage_developers' do
    it 'Gets all developers and assigns to @developers' do
      get :manage_developers, params: { id: project.id }

      expect(assigns(:developers)).to eq([developer])
    end
  end

  describe 'PATCH /add_developer' do
    it 'Adds developer to the project' do
      expect do
        patch :add_developer, params: { id: project.id, developer_id: developer.id }
      end.to change(project.reload.users, :count).by(1)
    end
  end
end
