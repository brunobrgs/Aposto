# encoding: utf-8
class ChallengesController < ApplicationController

  before_filter :set_current_user
  before_filter :find_challenge, :only => [:edit, :update, :destroy]

  def index
    if current_user
      @challenges = current_user.my_challenges.paginate(:page => params[:page])
    else
      redirect_to root_path
    end
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
    flash[:error] = errors(@challenge) unless @challenge.destroy
    respond_with(@challenge)
  end

  def vote
    if params[:option]
      option = Option.find(params[:option][:id])
      if option.vote(current_user)
        flash[:notice] = "Voto confirmado!"
      else
        flash[:error] = errors(option)
      end
    else
      flash[:error] = "Selecione a opção para realizar o voto."
    end
    redirect_to :action => :show, :id => params[:id]
  end

  private

  def find_challenge
    @challenge = Challenge.find(params[:id])
    redirect_to root_path if @challenge.user != current_user
  end

end
