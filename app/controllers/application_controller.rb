class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :current_user, :admin?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_user
    @current_user ||= Person.find(session[:user_id]) if session[:user_id]
  end

  def user_not_authorized
    @msg = 'You are not authorized to perform this action.'
    if request.xhr?
      render 'shared/unauthorized'
    else
      flash[:danger] = @msg
      redirect_to request.headers['Referer'] || root_url
    end
  end

  def admin?
    current_user && current_user.admin?
  end
end
