require 'rails_helper'

RSpec.describe DevelopersController, type: :controller do
  let!(:project_lead) { create(:user, role: 0) }
  let!(:developer) { create(:user, role: 1, lead_id: project_lead.id) }
  let!(:project) { create(:project) }

  before do
    sign_in(project_lead)
  end

  describe 'GET /new' do
    it 'Renders a successful response' do
      get :new

      expect(response.status).to eql(200)
    end

    it 'assigns a new developer to @developer' do
      get :new

      expect(assigns(:developer)).to be_a_new(User)
    end
  end

  describe 'GET /edit' do
    it 'Render a successful response' do
      get :edit, params: { id: developer.id }

      expect(response.status).to eql(200)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before do
        @valid_params = { user: { user_name: Faker::Name.unique.name,
                                  email: Faker::Internet.email,
                                  password: Faker::Internet.password,
                                  role: 'developer' } }
        end

      it 'Creates a new developer user' do
        expect do
          post :create, params: @valid_params
        end.to change(User, :count).by(1)
      end

      it 'Redirects to the root path' do
        post :create, params: @valid_params

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      before do
        @invalid_params = { user: { user_name: '',
                                    email: '',
                                    password: '' } }
      end

      it 'Does not create a new User because of empty name' do
        expect do
          post :create, params: @invalid_params
        end.to change(User, :count).by(0)
      end

      it 'Does not create a new User because of empty name' do
        post :create, params: @invalid_params

        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'Updates developer' do
        user_name = 'Test Developer'
        patch :update, params: { user: { user_name: user_name }, id: developer.id }

        expect(developer.reload.user_name).to eql(user_name)
      end

      it 'Redirects to the root path' do
        patch :update, params: { user: { user_name: 'Test Developer' }, id: developer.id }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'Renders edit when the user name is blank' do
        patch :update, params: { user: { user_name: '' }, id: developer.id }

        response.should render_template("edit")
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'Redirects to root path after developer deletion' do
      delete :destroy, params: { id: developer.id }

      expect(response).to redirect_to(root_path)
    end

    it 'Will not delete developer because of no developer id' do
      expect do
        delete :destroy
      end.to raise_error(ActionController::UrlGenerationError)
    end
  end
end
