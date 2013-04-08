class Position < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :time, :track_id, :speed, :height, :angle

  default_scope :order => "time ASC"

  belongs_to :track, :touch => true, :dependent => :destroy
  belongs_to :user

  validates_associated :track


  validates :latitude, :presence => true
  validates_numericality_of :latitude

  validates :longitude, :presence => true
  validates_numericality_of :longitude

  before_create :add_time

  after_save :update_track


  def latitude= latitude
    if latitude.class==String
      if match= /\d+\.\d+([NSns])$/.match(latitude)
        latitude.delete! match[1]
        latitude=latitude.to_f

        latitude *= -1 if match[1].downcase=='s'
      end
    end

    write_attribute(:latitude,latitude)
  end

  def longitude= longitude
    if longitude.class==String
      if match= /\d+\.\d+([NSns])$/.match(longitude)
        longitude.delete! match[1]
        longitude=longitude.to_f

        longitude *= -1 if match[1].downcase=='w'
      end
    end

    write_attribute(:longitude,longitude)
  end


  private

  def add_time
    self.time ||= Time.now
  end


  def update_track
    self.track.calculate_distance
  end




end
