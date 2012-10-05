class Vehicle < ActiveRecord::Base
  attr_accessible :name, :user_id

  belongs_to :user
  has_many :tracks, dependent: :destroy


  validates :name, :presence => true, :uniqueness => true,  length: { minimum: 4 }

end
