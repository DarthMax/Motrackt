require 'digest/sha2'

class User < ActiveRecord::Base

  has_many :vehicles, dependent: :destroy
  has_many :tracks, through: :vehicles

  validates :name, presence: true, uniqueness: true, length: { minimum: 4 }
  validates :email, presence: true, uniqueness: true, format: { with: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, message: "is not a valid email" }

  # validates the password
  # on create
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, on: :create
  # on update
  validates :password, confirmation: true, length: { minimum: 8 }, allow_blank: true, on: :update
  # validates the password confirmation
  validates :password_confirmation, presence: true, if: Proc.new{ |user| user.password.present? }



  attr_accessible :name, :email, :password, :password_confirmation
  attr_accessor :password, :password_encrypted

  scope :managed_by, lambda { |user|
    where( id: user.id )
  }

  # check if a user exists and if the given password matches this user
  def self.authenticate name, password
    user = User.find_by_name( name )
    if user.nil?
      return nil
    end

    if User.encrypt( password, user.salt ) == user.hashed_password
      return user
    else
      return nil
    end
  end

  # encrypts a password with a salt
  def self.encrypt password, salt
    hashed_password = Digest::SHA512.base64digest( password + salt )
    1000.times do
      hashed_password = Digest::SHA512.base64digest( hashed_password + salt )
    end

    return hashed_password
  end

  # set the password and update the hashed_password at the same time
  def password=( password )
    @password = password

    if self.password.present?
      self.salt ||= Digest::SHA512.base64digest( Time.now.to_s )
      self.hashed_password = User.encrypt( @password, self.salt )
    end
  end

end
