class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :condense

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = "Access denied."
    redirect_to root_path
  end

  private

  def current_user
    @current_user ||= Person.find(session[:user_id]) if session[:user_id]
  end

  def condense(content, len=25)
    content ||= ''
    content.length > len ? "#{content[0,len]}..." : content
  end
end
