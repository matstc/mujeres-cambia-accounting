class RegistroController < ApplicationController

  # The json from Twilio looks like that:
  #
  # {"AccountSid"=>"AC533c3d4bbc6bc26c29c632bf4f9e0f85", "Body"=>"Test2", "ToZip"=>"03079", "FromState"=>"", "ToCity"=>"SALEM", "SmsSid"=>"SM6c69ad427c5b29b48ea3af094373f9a6", "ToState"=>"NH", "To"=>"+16031234567", "ToCountry"=>"US", "FromCountry"=>"ES", "SmsMessageSid"=>"SM6c69ad427c5b29b48ea3af094373f9a6", "ApiVersion"=>"2010-04-01", "FromCity"=>"", "SmsStatus"=>"received", "From"=>"+34123456789", "FromZip"=>""}

  def add
    body = params["Body"]
    logger.info "Trying to add new accounting record: #{body}"

    Registro.new.add_row AccountingRow.new(body)
    @reply = "Thanks. Registro was updated."

    render :template => 'sms_response'
  end

  def transfer
    body = params["Body"]
    logger.info "Trying to execute a transfer: #{body}"

    Registro.new.transfer_row AccountingRow.new(body)
    @reply = "Thanks. Registro was updated."

    render :template => 'sms_response'
  end
end
