# encoding: utf-8
class Vote

  def self.make(user, option)
    @user = user
    @option = option
    ActiveRecord::Base.transaction do
      verify_bet_value
      Credit.subtract(@user, @option.bet_value, :vote)
      create_user_vote
    end
  end

  private

  def self.verify_bet_value
    raise "Você não possui saldo suficiente." unless @user.have_credit?(@option.bet_value)
  end

  def self.create_user_vote
    uv = UserVote.new
    uv.user = @user
    uv.option = @option
    uv.save!
  end

end
