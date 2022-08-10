class HolidayDiscountsController < ApplicationController

  def new
    @holiday_name = params[:holiday_name]
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    if holiday_discount_params[:percent_discount] == "" || holiday_discount_params[:quantity_threshold] == ""
      flash[:notice] = "Error - please complete all fields"

      redirect_to new_merchant_holiday_discount_path(holiday_discount_params[:merchant_id])
    else
      HolidayDiscount.create(percent_discount: holiday_discount_params[:percent_discount], quantity_threshold: holiday_discount_params[:quantity_threshold], holiday_name: holiday_discount_params[:holiday_name],merchant_id: holiday_discount_params[:merchant_id])

      redirect_to merchant_bulk_discounts_path(holiday_discount_params[:merchant_id])
    end
  end

  private
  def holiday_discount_params
    params.permit(:merchant_id, :percent_discount, :quantity_threshold, :holiday_name)
  end

end