class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
