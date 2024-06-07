class BulkDiscountsController < ApplicationController
    def index
        @merchant = Merchant.find(params[:merchant_id])
    end

    def show
    end

    def new
        @merchant = Merchant.find(params[:merchant_id])
        @bulk_discount = BulkDiscount.new
    end

    def create
        @merchant = Merchant.find(params[:merchant_id])
        @discount = @merchant.bulk_discounts.new(
            percentage_discount: (bulk_discount_params[:percentage_discount].to_i / 100.0).to_f,
            quantity_threshold: bulk_discount_params[:quantity_threshold].to_i,
            merchant_id: params[:merchant_id]
        )
        if @discount.save
            redirect_to merchant_bulk_discounts_path(params[:merchant_id])
        end
    end

    private
    def bulk_discount_params
        params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold, :merchant_id)
    end
end