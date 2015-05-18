class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|

      t.string :roles

    end
  end
end
