class AreasController < ApplicationController
  def new
  end

  def create
    @number = params[:area][:number]
    begin
      DecipherArea.new(number: @number).process
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
