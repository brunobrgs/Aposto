# encoding: utf-8
class Challenge < ActiveRecord::Base

  extend FriendlyId
  friendly_id :question, use: :slugged

  attr_accessor :vote
  attr_accessible :bet_value, :correct_option_id, :end_date, :max_bets, :private, :question, :options_attributes

  belongs_to :user
  has_many :options, :dependent => :destroy
  belongs_to :correct_option, :class_name => Option
  accepts_nested_attributes_for :options, :allow_destroy => true

  validates :bet_value, :end_date, :max_bets, :question, :presence => true

  def self.publics(page=1)
    Challenge.where(:private => false).order(&:end_date).paginate(:page => page)
  end

  def belong_to(user)
    self.user == user
  end

  def answers_with_id
    self.options.map { |opt| [opt.answer, opt.id] }
  end

  def initiated?
    !self.start_date.blank?
  end

  def can_be_voted?
    self.initiated? || self.belong_to(User.current)
  end

  validate :verify_user, :on => :update

  def verify_user
    errors.add(:base, 'Você não pode fazer essa alteração') unless self.belong_to(User.current)
  end

end
