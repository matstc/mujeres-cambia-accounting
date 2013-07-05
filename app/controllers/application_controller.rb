class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_variables

  @@COMMANDS = {
    "A" => :registro_add_path,
    "T" => :registro_transfer_path
  }

  def check_variables
    if ENV['gmail'].blank? or ENV['gmailp'].blank?
      message = "The configuration variables \"gmail\" and \"gmailp\" are not set on the server. Make sure you set these configuration variables and restart the server."

      logger.warn message
      flash[:warning] = message
    end
  end
 
  def process_sms
    body = params["Body"]
    logger.info "Received new sms: #{body}"
    sms_code = body.split(",")[0].upcase

    if @@COMMANDS.include? sms_code
      method = Rails.application.routes.url_helpers.method(@@COMMANDS[sms_code])
      redirect_to(method.call(params)) and return 
    end

    @reply = I18n.t("response.unrecognized_code", :code => sms_code)
    render :template => 'sms_response'
  end

  def index
  end
end
