# encoding: utf-8
class Challenge < ActiveRecord::Base

  attr_accessible :bet_value, :correct_option, :end_date, :max_bets, :private, :question, :options_attributes

  belongs_to :user
  has_many :options, :dependent => :destroy
  accepts_nested_attributes_for :options, :allow_destroy => true

  validates :bet_value, :end_date, :max_bets, :question, :presence => true

  def belong_to(user)
  	self.user == user
  end

  validate :verify_user, :on => :update

  def verify_user
    errors.add(:base, 'Você não pode fazer essa alteração') if true#User.current != self.user
  end

end
