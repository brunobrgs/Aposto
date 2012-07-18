require "app_responder"

class ApplicationController < ActionController::Base
  protect_from_forgery

  self.responder = AppResponder
  respond_to :html

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def set_current_user
  	User.current = current_user
  end
end