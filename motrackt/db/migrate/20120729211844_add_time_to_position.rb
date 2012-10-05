class AddTimeToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :time, :datetime
  end
end
