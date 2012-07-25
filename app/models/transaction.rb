# encoding: utf-8
class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :related, :polymorphic => true
  attr_protected :user_id, :ident, :related_id, :related_type, :value

  def description
    case self.ident.to_sym
      when :nc then 'Inserção de crédito' # new_credit
      when :v then 'Voto realizado'       # vote
      when :ca then 'Prêmio de desafio'   # challenge_award
      else
        ''
    end
  end

  def related_desc
    '-'
  end

  before_create :treat_ident

  def treat_ident
    # See: description of transaction
    case self.ident
      when :vote then self.ident = :v
    end
  end

end
