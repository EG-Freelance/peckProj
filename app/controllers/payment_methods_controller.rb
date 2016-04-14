class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: [:show]
  
  def save_payment_option
    @payment_method = PaymentMethod.new(payment_method_params)
    @payment_method.user_id = current_user.id
    if @payment_method.save
      respond_to do |format|
        format.html { redirect_to :back }
        format.js { }
      end
    else
      render :template => 'payment_methods/payment_method_create_error'
    end
  end
  
  private
    def set_payment_method
      @payment_method = PaymentMethod.find(params[:id])
    end

    def payment_method_params
      params.require(:payment_method).permit(:provider, :username, :custom_name, :user_id)
    end
end
