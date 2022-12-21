# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserProject, type: :model do
  describe 'Model tests for UserProject' do
    context 'associations' do
      it { should belong_to(:project) }
      it { should belong_to(:user) }
    end
  end
end
