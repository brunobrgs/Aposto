# encoding: utf-8
class Credit

  def self.add(user, value, ident, related = nil)
    ActiveRecord::Base.transaction do
      # Change the credit value of the user
      user.credit += value
      user.save!
      transaction_log(user, value, ident, related)
    end
  end

  def self.subtract(user, value, ident, related = nil)
    ActiveRecord::Base.transaction do
      # Change the credit value of the user
      user.credit -= value
      user.save!
      transaction_log(user, -value, ident, related)
    end
  end

  private

  def self.transaction_log(user, value, ident, related = nil)
    t = Transaction.new
    t.user = user
    t.value = value
    t.ident = ident
    t.related = related
    t.save!
  end

end
