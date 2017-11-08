class WelcomeController < ApplicationController
  # GET /welcome
  def index
    redirect_to links_path if current_user
  end
end
