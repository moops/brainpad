class WelcomeController < ApplicationController
  skip_after_filter :store_last_good_page
  
  # GET /welcome
  def index
    if current_user
      redirect_to links_path
    end
  end
end
