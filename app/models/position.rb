class Position < ActiveRecord::Base
  attr_accessible :latitude, :longitude,:time, :track_id

  default_scope :order => "time ASC"

  belongs_to :track, :touch => true
  belongs_to :user

  validates_associated :track


  validates :latitude, :presence => true
  validates_numericality_of :latitude

  validates :longitude, :presence => true
  validates_numericality_of :longitude

  before_create :add_time

  after_save :update_track

  private

  def add_time
    self.time ||= Time.now
  end


  def update_track
    self.track.calculate_distance_and_speed
  end


end
