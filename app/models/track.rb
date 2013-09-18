class Track < ActiveRecord::Base
  attr_accessible :description, :name, :vehicle_id

  has_many :positions, :dependent => :delete_all
  belongs_to :vehicle
  belongs_to :user


  def name
    read_attribute(:name) || "Unnamed Track"
  end

  def speed
    positions.sum(&:speed)/positions.count.to_f
  end

  def calculate_distance
    return 0 if positions.count < 2
    sum=0
    positions.order(:created_at).each_cons(2) do |pos1,pos2|
      sum += lon_lat_to_distance(pos1,pos2)
    end

    self.distance = sum

    self.save!
  end


  private

  def lon_lat_to_distance(point_a,point_b)
    r = 6371

    d_lat = to_rad(point_b.latitude - point_a.latitude)
    d_lon = to_rad(point_b.longitude-point_a.longitude)

    lat1 = to_rad(point_a.latitude)
    lat2 = to_rad(point_b.latitude)

    a = Math.sin(d_lat/2) * Math.sin(d_lat/2) + Math.sin(d_lon/2) * Math.sin(d_lon/2) * Math.cos(lat1) * Math.cos(lat2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    r * c
  end


  def to_rad(deg)
    deg * Math::PI / 180
  end

end
