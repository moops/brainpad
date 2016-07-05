class WelcomeController < ApplicationController
  # GET /welcome
  def index
    if current_user
      redirect_to links_path
    end
  end
end
