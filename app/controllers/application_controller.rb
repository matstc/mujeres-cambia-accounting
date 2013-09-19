class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_variables

  @@COMMANDS = {
    "A" => "Registro.new.method(:add_row)",
    "T" => "Registro.new.method(:transfer)",
    "I" => "Registro.new.method(:state_of_one_account)",
    "INFORME" => "Registro.new.method(:state_of_all_accounts)"
  }

  def check_variables
    if ENV['gmail'].blank? or ENV['gmailp'].blank?
      message = "The configuration variables \"gmail\" and \"gmailp\" are not set on the server. Make sure you set these configuration variables and restart the server."

      logger.warn message
      flash[:warning] = message
    end
  end
 
  def process_sms
    sms = params["Body"]
    logger.info "Received new sms: #{sms}"

    bodies = sms.split(";")
    responses = []
    bodies.each {|body_string|
      begin
        responses << process_single_body_string(body_string)
      rescue Exception => e
        logger.warn "An exception was raised processing the sms: #{e.backtrace.join("\n")}"
        responses << e
      end
    }

    @reply = responses.map{|r|r.to_s}.join("; ")
    render :template => 'sms_response'
  end

  def index
  end

  private

  def process_single_body_string body_string
    body = body_string.split(",")
    sms_code = body[0].upcase

    if @@COMMANDS.include? sms_code
      method = eval(@@COMMANDS[sms_code])
      method.call(body.drop(1))
    else
      raise Exception.new(I18n.t("response.unrecognized_code", :code => sms_code))
    end
  end

end
