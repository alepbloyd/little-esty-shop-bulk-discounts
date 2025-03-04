class MerchantInvoicesController < ApplicationController
  def index 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = @merchant.invoices.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    invoice = Invoice.find(params[:id])
    invoice_item = InvoiceItem.find(params[:invoice_item_id])
    
    invoice_item.update!(status: invoice_item_params[:status].downcase)

    redirect_to "/merchants/#{merchant.id}/invoices/#{invoice.id}"
  end

  private
    def invoice_item_params
      params.permit(:status)
    end
end