class AddProgressToScenarioSessions < ActiveRecord::Migration
  def change
    add_column :scenario_sessions, :progress, :integer
  end
end
