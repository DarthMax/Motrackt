class Position < ActiveRecord::Base
  attr_accessible :latitude,:latitude_nmea, :longitude_nmea, :longitude, :time, :track_id, :speed, :height, :angle

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


  def latitude_nmea= latitude
    if latitude.class==String
      multiplicand=1
      if match= /\d+\.\d+([NSns])$/.match(latitude)
        latitude.delete! match[1]

        multiplicand= -1 if match[1].downcase=='s'
      end

      degrees=latitude.slice!(0..1).to_f+ latitude.to_f/60
      latitude=degrees*multiplicand
    end

    write_attribute(:latitude,latitude)
  end

  def longitude_nmea= longitude
    if longitude.class==String
      multiplicand=1
      if match= /\d+\.\d+([EWew])$/.match(longitude)
        longitude.delete! match[1]

        multiplicand= -1 if match[1].downcase=='w'
      end

      degrees=longitude.slice!(0..2).to_f + longitude.to_f/60
      longitude=degrees*multiplicand
    end

    write_attribute(:longitude,longitude)
  end

  def speed=(speed)
    write_attribute :speed, speed*1.852
  end


  private

  def add_time
    self.time ||= Time.now
  end


  def update_track
    self.track.update_meta_data
  end




end
