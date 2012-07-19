class HomeController < ApplicationController
  def index
    @challenges = Challenge.availables(params[:page])
  end
end
