class User < ActiveRecord::Base
  
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :challenges
  has_many :user_votes
  has_many :transactions

  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end

  # List of challenges that the user is participating
  def challenges_in
    Challenge.includes({:options => :user_votes}).where("user_votes.user_id = #{self.id}")
  end

  # Created challenges + Paticipating challenges
  def my_challenges
    (self.challenges+self.challenges_in).flatten.uniq
  end

  # Alredy voted at option ?
  def voted_for?(option_id)
    self.user_votes.where(:option_id => option_id).blank? ? false : true
  end

  # If the user voted at the challenge, he can't vote again
  def can_vote_in?(challenge)
    challenge.options.each {|opt| return false if self.voted_for?(opt.id) }
  end

  # Have more or the same value passed ?
  def have_credit?(value)
    self.credit >= value
  end

end
