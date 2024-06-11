class BulkDiscountsController < ApplicationController
    def index
        @merchant = Merchant.find(params[:merchant_id])
    end

    def show
        @bulk_discount = BulkDiscount.find(params[:id])
        @merchant = Merchant.find(params[:merchant_id])
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

    def destroy
        @discount = BulkDiscount.find(params[:id])
        @discount.destroy
        redirect_to merchant_bulk_discounts_path(params[:merchant_id])
    end

    def edit
        @merchant = Merchant.find(params[:merchant_id])
        @bulk_discount = BulkDiscount.find(params[:id])
        @bulk_discount.percentage_discount = (@bulk_discount.percentage_discount * 100).to_i
    end

    def update
        @bulk_discount = BulkDiscount.find(params[:id])
        if @bulk_discount.update(
            percentage_discount: (bulk_discount_params[:percentage_discount].to_i / 100.0).to_f,
            quantity_threshold: bulk_discount_params[:quantity_threshold].to_i,
            merchant_id: params[:merchant_id]
        )
            redirect_to merchant_bulk_discount_path(@bulk_discount.merchant, @bulk_discount)
        end
    end

    private
    def bulk_discount_params
        params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold, :merchant_id)
    end
end