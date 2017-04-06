module Spree
  class Admin::StoreCreditsController < Admin::ResourceController
    before_filter :check_amounts, :only => [:edit, :update]
    prepend_before_filter :set_remaining_amount, :only => [:create, :update]

    def index
      params[:q] ||= {}
      @search = Spree::StoreCredit.search(credit_params(params))
      unless params[:q].blank?  
        @store_credits = @search.result(distinct: true).page(params[:page]).per(25)
      end
    end

    protected
      def permitted_resource_params
        params.require(:store_credit).permit(permitted_store_credit_attributes)
      end

    private
    def check_amounts
      if (@store_credit.remaining_amount < @store_credit.amount)
        flash[:error] = Spree.t(:cannot_edit_used)
        redirect_to spree.admin_store_credits_path
      end
    end

    def set_remaining_amount
      params[:store_credit][:remaining_amount] = params[:store_credit][:amount] if params[:store_credit]
    end

    def collection
      # TODO: PMG - Figure out how we can integrate with accessible_by
      Spree::StoreCredit.all.page(params[:page] || 1)
    end

    def permitted_store_credit_attributes
      [:user_id, :amount, :reason, :remaining_amount]
    end

    def credit_params(params)
      if !params[:q][:created_at_gt].blank?
        created_start = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
      end
      if !params[:q][:created_at_lt].blank?
        created_end = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
      end
      { user_email_cont: params[:q][:user_email_cont], created_at_gt: created_start, created_at_lt: created_end }
    end

  end
end
