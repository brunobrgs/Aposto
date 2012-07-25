# encoding: utf-8
class Option < ActiveRecord::Base
  belongs_to :challenge
  has_many :user_votes, :dependent => :destroy
  attr_accessible :answer

  delegate :bet_value, :to => :challenge

  def vote(user)
    begin
      Vote.make(user, self)
      true
    rescue
      errors.add(:base, "#{$!}")
      false
    end
  end

end
