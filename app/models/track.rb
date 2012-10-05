class Track < ActiveRecord::Base
  attr_accessible :description, :distance, :name, :vehicle_id

  has_many :positions, :dependent => :destroy
  belongs_to :vehicle
end
