module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      # what is ||= (t-square operator)
      # a ||= 1  # a assign to 1
      # a ||= 50 # a is already assigned, a will not be assigned again
      # puts a
      #=> 1
      
      @current_user ||= User.find_by(id: session[:user_id])
      # it sees if @current_user is nil or not. If it has some value, leave it alone(the current user) Else, get the current user from the session using the user id.
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  # def redirect_back_or(default)
  #   redirect_to(session[:forwarding_url] || default)
  #   session.delete(:forwarding_url)
  # end

  # def store_location
  #   session[:forwarding_url] = request.original_url if request.get?
  # end
end
