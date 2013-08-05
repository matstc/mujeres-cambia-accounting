class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_variables

  @@COMMANDS = {
    "A" => "Registro.new.method(:add_row)",
    "T" => "Registro.new.method(:transfer)"
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
    exceptions = []
    bodies.each {|body_string|
      begin
        process_single_body_string body_string
      rescue Exception => e
        exceptions << e
      end
    }

    @reply = manufacture_response(exceptions)
    render :template => 'sms_response'
  end

  def index
  end

  private
  def manufacture_response exceptions
    if exceptions.empty?
      I18n.t("response.success")
    elsif exceptions.size > 1
      "#{I18n.t("response.errors")} #{exceptions.map {|e| e.to_s}.join(" ")}"
    else
      "#{exceptions.map {|e| e.to_s}.join(" ")}"
    end
  end

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
