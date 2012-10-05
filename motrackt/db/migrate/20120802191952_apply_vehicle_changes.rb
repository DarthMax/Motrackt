class ApplyVehicleChanges < ActiveRecord::Migration
 def change
   rename_column :tracks, :user_id, :vehicle_id
 end
end
