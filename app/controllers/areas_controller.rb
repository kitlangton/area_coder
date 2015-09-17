class AreasController < ApplicationController
  def new
    @numbers = PhoneNumber.order(updated_at: :desc).limit(5)
    @gmail = SupportEmail.new.pending
  end

  def create
    @number = params[:area][:number]
    begin
      phone = DecipherArea.new(number: @number)
      phone.process
      PhoneNumber.find_or_create_by(number: phone.digits).touch
      redirect_to area_path(@number)
    rescue
      render :new
    end
  end

  def show
    @number = params[:number]
    @response = DecipherArea.new(number: @number).process
  end
end
