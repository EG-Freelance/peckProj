class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
  
  def batch_invite
    emails = [params[:user][:email]]
    @registry = params[:user][:registry]
    emails.each do |f| 
      if User.exists?(email: f)
        UserRegistry.find_or_create_by(user_id: User.find_by(email: f), registry_id: @registry, association_type: "administrator")
      else
        u = User.invite!(:email => f)
        UserRegistry.create(user_id: u.id, registry_id: @registry, association_type: "administrator")
      end
    end
    respond_to do |format|
      format.html { redirect_to :back, notice: "Invitations sent" }
    end
  end
  
  def create
    adjusted_sign_up_params = sign_up_params
    if adjusted_sign_up_params[:owner_id]
      unless User.find_by(email: adjusted_sign_up_params[:owner_id]).nil?
        adjusted_sign_up_params[:owner_id] = User.find_by(email: adjusted_sign_up_params[:owner_id]).id
      else
        adjusted_sign_up_params[:owner_id] = "Error"
      end
    else
      adjusted_sign_up_params[:owner_id] = nil
    end
    
    @user = User.new(adjusted_sign_up_params)
    
    if @user.owner_id == "Error"
      @user.errors.add(:owner_id, 'Either email address is invalid or account already exists.  Please try again.')
    end
    

    respond_to do |format|
      if @user.save
        
        format.html { redirect_to root_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to root_url, :flash => { :error => "Either email address is invalid or account already exists.  Please try again."} }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  private

    def sign_up_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :owner_id, :preferred_payment, :venmo_acct, :paypal_acct)
    end

    def account_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :owner_id, :current_password, :preferred_payment, :venmo_acct, :paypal_acct)
    end

end
