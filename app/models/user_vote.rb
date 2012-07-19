# encoding: utf-8
class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :option

  def is_first_vote?
    # Verify if this is the first vote of the challenge
    votes = self.option.user_votes
    votes.size == 1 && votes.first == self
  end

  validate :verifications, :on => :create
  after_create :start_challenge

  def verifications
    errors.add(:base, 'Não pode receber votos.') unless self.option.challenge.can_be_voted?
    errors.add(:base, 'Você já votou nesse desafio.') unless self.user.can_vote_in?(self.option.challenge)
  end

  def start_challenge
    # When the challenge receive the first vote, it is started
    if self.is_first_vote?
      ch = self.option.challenge
      ch.start_date = Date.today
      ch.save(:validate => false)
    end
  end


end
