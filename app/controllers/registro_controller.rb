class RegistroController < ApplicationController
  before_filter :parse_body

  # The json from Twilio looks like that:
  #
  # {"AccountSid"=>"AC533c3d4bbc6bc26c29c632bf4f9e0f85", "Body"=>"Test2", "ToZip"=>"03079", "FromState"=>"", "ToCity"=>"SALEM", "SmsSid"=>"SM6c69ad427c5b29b48ea3af094373f9a6", "ToState"=>"NH", "To"=>"+16031234567", "ToCountry"=>"US", "FromCountry"=>"ES", "SmsMessageSid"=>"SM6c69ad427c5b29b48ea3af094373f9a6", "ApiVersion"=>"2010-04-01", "FromCity"=>"", "SmsStatus"=>"received", "From"=>"+34123456789", "FromZip"=>""}
  def parse_body
    @body = params["Body"].split(",").drop(1)
  end

  def add
    logger.info "Trying to add new accounting record: #{@body}"

    Registro.new.add_row AccountingRow.new(@body)
    @reply = I18n.t "response.success"

    render :template => 'sms_response'
  end

  def transfer
    logger.info "Trying to execute a transfer: #{@body}"

    AccountingRow.create_transfer(@body).inject(Registro.new){|registro, row| registro.add_row(row); registro}
    @reply = I18n.t "response.success"

    render :template => 'sms_response'
  end
end
