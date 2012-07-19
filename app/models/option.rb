# encoding: utf-8
class Option < ActiveRecord::Base
  belongs_to :challenge
  has_many :user_votes, :dependent => :destroy
  attr_accessible :answer

  def vote(user)
    begin
      uv = UserVote.new
      uv.user = user
      uv.option = self
      uv.save!
    rescue
      errors.add(:base, "#{$!}")
      false
    end
  end

end
