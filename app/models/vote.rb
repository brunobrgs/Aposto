# encoding: utf-8
class Vote

  def self.make(user, option)
    @user = user
    @option = option
    ActiveRecord::Base.transaction do
      verify_bet_value
      user_vote = create_user_vote
      c = Credit.new(@user, @option.bet_value, :vote, user_vote)
      c.subtract
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
    uv
  end

end
