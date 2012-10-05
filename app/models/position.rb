class Position < ActiveRecord::Base
  attr_accessible :latitude, :longitude,:time, :track_id

  default_scope :order => "time ASC"

  belongs_to :track
  validates_associated :track


  validates :latitude, :presence => true
  validates_numericality_of :latitude

  validates :longitude, :presence => true
  validates_numericality_of :longitude


end
