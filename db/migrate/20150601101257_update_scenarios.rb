class UpdateScenarios < ActiveRecord::Migration
  def change
    change_column :scenarios, :roles, :text
    add_column :scenarios, :time_budget, :integer
    add_column :scenarios, :money_budget, :integer
    add_column :scenarios, :title, :string
    add_column :scenarios, :description, :text
    add_column :scenarios, :content, :text
  end
end
