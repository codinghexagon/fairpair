class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :sprint, null: false, foreign_key: true
      t.jsonb :pairs, default: {}
      t.timestamps
    end
  end
end
