class AddLeadReferenceToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :lead, index: true
  end
end
