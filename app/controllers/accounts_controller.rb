class AccountsController < ApplicationController

  load_and_authorize_resource

  # GET /accounts/new.js
  def new
  end

  # GET /accounts/1/edit.js
  def edit
  end

  # POST /accounts
  def create
    @account = current_user.accounts.build(account_params)
    if @account.save
      redirect_to payments_path
    end
  end

  # PUT /accounts/1
  def update
    @account = current_user.accounts.find(params[:id])
    if @account.update_attributes!(account_params)
      redirect_to payments_path
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
    redirect_to payments_path
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account).permit(:name, :url, :price_url, :description, :units, :price, :active)
  end
end
