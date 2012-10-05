class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.float :speed
      t.string :name
      t.text :description
      t.float :distance

      t.timestamps
    end
  end
end
