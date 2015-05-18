class CreateScenarioSessions < ActiveRecord::Migration
  def change
    create_table :scenario_sessions do |t|

      t.integer :scenario_id
      t.integer :student_id
      t.integer :teacher_id
      t.datetime :start_date
      t.datetime :end_date

    end
  end
end
