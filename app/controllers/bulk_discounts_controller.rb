class BulkDiscountsController < ApplicationController

  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @holiday_search = HolidaySearch.new
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id]) 
  end

  def create
    
    if bulk_discount_params[:percent_discount] == "" || bulk_discount_params[:quantity_threshold] == ""
      flash[:notice] = "Error - please complete all fields"

      redirect_to new_merchant_bulk_discount_path(bulk_discount_params[:merchant_id])
    else
      BulkDiscount.create(
        percent_discount: bulk_discount_params[:percent_discount],
        quantity_threshold: bulk_discount_params[:quantity_threshold],
        merchant_id: bulk_discount_params[:merchant_id]
      )

      redirect_to merchant_bulk_discounts_path(bulk_discount_params[:merchant_id]), notice: "New discount created!"
    end
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])

    if bulk_discount_params[:percent_discount].to_i > 100

      redirect_to edit_merchant_bulk_discount_path(@bulk_discount.merchant,@bulk_discount), notice: "Please enter a number under 100 for percentage"

    else

      @bulk_discount.update(percent_discount: bulk_discount_params[:percent_discount], quantity_threshold: bulk_discount_params[:quantity_threshold])

      redirect_to merchant_bulk_discount_path(@bulk_discount.merchant,@bulk_discount)

    end
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy

    redirect_to merchant_bulk_discounts_path(params[:merchant_id]), notice: "Discount deleted!"
  end

  private
  def bulk_discount_params
    params.permit(:merchant_id, :percent_discount, :quantity_threshold)
  end

end