# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User Model tests' do
    let(:user) { create(:user) }
    context 'validations' do
      it { should validate_presence_of(:user_name) }
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    end

    context 'associations' do
      it { should have_many(:user_projects) }
      it { should have_many(:projects).through(:user_projects) }
      it { should have_many(:subordinates).class_name('User') }
      it { should belong_to(:lead).class_name('User').optional }
    end

    context 'enums' do
      it { should define_enum_for(:role).with_values([:lead, :developer]) }
    end

    context 'scopes' do
      let(:testUser) { create(:user) }

      it 'should return users in descending order' do
        expect(User.id_ordered_desc).to include(testUser)
      end
    end

    context 'methods' do
      it 'should nullify password for developer' do
        expect(user.nullify_password_for_developers).to eq(true)
      end
    end
  end
end
