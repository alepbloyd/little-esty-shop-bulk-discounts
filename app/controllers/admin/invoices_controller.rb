class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update
    invoice = Invoice.find(params[:id])
    if params[:status] == "In Progress"
      invoice.update(status: "in_progress")
    end

    if params[:status] == "Cancelled"
      invoice.update(status: "cancelled")
    end

    if params[:status] == "Completed"
      invoice.update(status: "completed")
    end
    
    redirect_to "/admin/invoices/#{params[:id]}"
  end
end

