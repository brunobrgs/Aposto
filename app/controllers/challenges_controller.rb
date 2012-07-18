class ChallengesController < ApplicationController

  before_filter :set_current_user
  before_filter :find_challenge, :only => [:edit, :update, :destroy]

  def index
    @challenges = Challenge.publics(params[:page])
  end

  def show
    @challenge = Challenge.find(params[:id])
  end

  def new
    @challenge = Challenge.new
  end

  def edit
  end

  def create
    @challenge = Challenge.new(params[:challenge])
    @challenge.user = current_user
    @challenge.save
    respond_with(@challenge)
  end

  def update
    @challenge.update_attributes(params[:challenge])
    respond_with(@challenge)
  end

  def destroy
    @challenge.destroy
    respond_with(@challenge)
  end

  private

  def find_challenge
    @challenge = Challenge.find(params[:id])
    redirect_to root_path if @challenge.user != current_user
  end

end
