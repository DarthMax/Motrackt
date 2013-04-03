class Vehicle < ActiveRecord::Base
  attr_accessible :name, :user_id

  belongs_to :user
  has_many :tracks, dependent: :destroy


  validates :name, :presence => true, :uniqueness => true,  length: { minimum: 4 }



  def as_json(args)
    last_position=self.tracks.last.positions.last

    {
      vehicle: {
        name: self.name,
        last_position: {
            latitude: last_position.latitude,
            longitude: last_position.longitude
        }
      }
    }
  end
end
