# frozen_string_literal: true

class CreateSprints < ActiveRecord::Migration[7.0]
  def change
    create_table :sprints do |t|
      t.string :name
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
    add_index :sprints, :name, unique: true
  end
end
