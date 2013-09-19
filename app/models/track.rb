class Track < ActiveRecord::Base
  attr_accessible :description, :name, :vehicle_id

  has_many :positions, :dependent => :delete_all
  belongs_to :vehicle
  belongs_to :user


  def name
    read_attribute(:name) || "Unnamed Track"
  end

  def update_meta_data
    calculate_distance
    calculate_avg_speed
    calculate_height_difference
    self.save!
  end

  def height_data
    dataset_height = {
        :fillColor => "rgba(151,187,205,0.5)",
        :strokeColor => "rgba(151,187,205,1)",
        :pointColor => "rgba(151,187,205,1)",
        :pointStrokeColor => "#fff",
        :data => positions.map(&:height)
    }

    dataset_speed = {
        :fillColor => "rgba(205,155,155,0.5)",
        :strokeColor => "rgba(187,150,150,1)",
        :pointColor => "rgba(187,150,150,1)",
        :pointStrokeColor => "#fff",
        :data => positions.map(&:speed)
    }


    {
        :labels => positions.map {|p| p.time.strftime("%H:%M")},
        :datasets => [dataset_height,dataset_speed]
    }
  end

  def as_gpx
    file = GPX::GPXFile.new
    track = GPX::Track.new
    track.name = self.name
    segment = GPX::Segment.new

    self.positions.each do |pos|
      segment.points << GPX::TrackPoint.new(
          :lon => pos.longitude,
          :lat => pos.latitude,
          :time => pos.time,
          :elevation => pos.height,
          :speed => pos.speed
      )
    end
    track.segments << segment
    file.tracks << track

    file
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

  def calculate_distance
    return 0 if positions.count < 2
    sum=0
    positions.order(:created_at).each_cons(2) do |pos1,pos2|
      sum += lon_lat_to_distance(pos1,pos2)
    end
    self.distance = sum
  end

  def calculate_avg_speed
    self.avg_speed = positions.sum(&:speed)/positions.count.to_f
  end

  def calculate_height_difference
    return 0 if positions.count < 2
    sum=0
    positions.order(:created_at).each_cons(2) do |pos1,pos2|
      sum += (pos1.height-pos2.height).abs
    end
    self.height_difference = sum
  end

end
