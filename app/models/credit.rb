# encoding: utf-8
class Credit

  def initialize(user, value, ident, related = nil)
    @user = user
    @value = value
    @ident = ident
    @related = related
  end

  def add
    ActiveRecord::Base.transaction do
      # Change the credit value of the user
      @user.credit += @value
      @user.save!
      transaction_log
    end
  end

  def subtract
    ActiveRecord::Base.transaction do
      # Change the credit value of the user
      @user.credit -= @value
      @user.save!
      transaction_log
    end
  end

  private

  def transaction_log
    t = Transaction.new
    t.user = @user
    t.value = @value
    t.ident = @ident
    t.related = @related
    t.save!
  end

end
