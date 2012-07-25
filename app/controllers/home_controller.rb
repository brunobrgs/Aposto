class HomeController < ApplicationController

  def index
    @challenges = Challenge.availables(params[:page])
  end

  def transactions
    @transactions = current_user ? current_user.transactions.paginate(:page => params[:page]) : []
  end

end
