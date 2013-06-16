class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_variables

  def check_variables
    if ENV['gmail'].blank? or ENV['gmailp'].blank?
      message = "The configuration variables \"gmail\" and \"gmailp\" are not set on the server. Make sure you set these configuration variables and restart the server."

      logger.warn message
      flash[:warning] = message
    end
  end
 
  def index
  end
end
