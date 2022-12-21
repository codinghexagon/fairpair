# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Project Model tests' do
    let(:project) { create(:project) }
    context 'validations' do
      it { should validate_presence_of(:name) }
      # it { should validate_uniqueness_of(:name) }
    end

    context 'associations' do
      it { should have_many(:user_projects) }
      it { should have_many(:users).through(:user_projects) }
    end
  end
end 
