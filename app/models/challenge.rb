# encoding: utf-8
class Challenge < ActiveRecord::Base

  extend FriendlyId
  friendly_id :question, use: :slugged

  attr_accessible :bet_value, :correct_option_id, :end_date, :max_bets, :private, :question,
                  :options_attributes

  belongs_to :user
  has_many :options, :dependent => :destroy
  belongs_to :correct_option, :class_name => Option
  accepts_nested_attributes_for :options, :allow_destroy => true

  validates :bet_value, :end_date, :max_bets, :question, :presence => true

  def self.availables(page=1, private=false)
    Challenge.where("private = #{private} and start_date is not null").order(&:end_date).paginate(:page => page)
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

  def max_bets_reached?
    self.votes.size == self.max_bets
  end

  def can_be_voted?
    User.current && (self.initiated? || self.belong_to(User.current)) && !self.max_bets_reached?
  end

  def situation(user)
    s = ''
    if self.belong_to(user)
      s = self.initiated? ? 'Iniciado' : 'Criado'
    else
      s = 'Participando'
    end
    s
  end

  def can_be_changed?
    self.belong_to(User.current) && (!self.initiated? || self.defining_correct_option?)
  end

  def can_be_destroyed?
    self.can_be_changed?
  end

  def votes
    self.options.collect(&:user_votes).flatten
  end

  def defining_correct_option?
    self.changed? && self.changes.size == 1 && self.changes.has_key?('correct_option_id')
  end

  validate :can_change?, :on => :update
  before_destroy :can_destroy?

  def can_change?
    errors.add(:base, 'Você não pode fazer essa alteração.') unless self.belong_to(User.current)
    errors.add(:base, 'Não pode ser alterado. Já foi iniciado.') if self.initiated? && !self.defining_correct_option?
  end

  def can_destroy?
    self.can_change?
    errors.blank? ? true : false
  end

end
