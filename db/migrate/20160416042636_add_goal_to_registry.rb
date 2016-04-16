class AddGoalToRegistry < ActiveRecord::Migration
  def change
    change_table :registries do |t|
      t.decimal :goal
    end
  end
end
