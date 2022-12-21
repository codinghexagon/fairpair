require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User Model tests' do
    let(:user) { create(:user) }
    context 'validations' do
      it { should validate_presence_of(:user_name) }
      it { should validate_presence_of(:email) }
    end

    context 'associations' do
      it { should have_many(:user_projects) }
      it { should have_many(:projects).through(:user_projects) }
    end
  end
end
