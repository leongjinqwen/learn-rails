class SessionsController < ApplicationController
  # show login form
  def new
  end

  # check password, then login user
  def create
    # get user from db
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to user_path(@user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end  
  end

  # logout user
  def destroy
    log_out
    redirect_to root_path
  end
end
