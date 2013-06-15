class RegistroController < ApplicationController
  def add
    logger.info "Received new accounting row: #{params[:body]}"

    render :text => "Success"
  end
end
