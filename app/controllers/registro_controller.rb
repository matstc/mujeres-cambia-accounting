class RegistroController < ApplicationController

  # The json from Twilio looks like that:
  #
  # {"AccountSid"=>"AC533c3d4bbc6bc26c29c632bf4f9e0f85", "Body"=>"Test2", "ToZip"=>"03079", "FromState"=>"", "ToCity"=>"SALEM", "SmsSid"=>"SM6c69ad427c5b29b48ea3af094373f9a6", "ToState"=>"NH", "To"=>"+16036853737", "ToCountry"=>"US", "FromCountry"=>"ES", "SmsMessageSid"=>"SM6c69ad427c5b29b48ea3af094373f9a6", "ApiVersion"=>"2010-04-01", "FromCity"=>"", "SmsStatus"=>"received", "From"=>"+34695307711", "FromZip"=>""}
  #
  def add
    body = params["Body"]
    logger.info "Received new accounting row: #{body}"

    Registro.new.add_row body.split(",")
    render :text => "Success"
  end
end
