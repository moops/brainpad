class AccountsController < ApplicationController

  # GET /accounts/new.js
  def new
    @account = Account.new
    authorize @account
  end

  # GET /accounts/1/edit.js
  def edit
    @account = Account.find(params[:id])
    authorize @account
  end

  # POST /accounts
  def create
    @account = current_user.accounts.build(account_params)
    authorize @account
    if @account.save
      redirect_to accounts_path
    end
  end

  # PUT /accounts/1
  def update
    @account = Account.find(params[:id])
    authorize @account
    if @account.update_attributes!(account_params)
      redirect_to accounts_path
    end
  end

  # DELETE /accounts/1
  def destroy
    @account = Account.find(params[:id])
    authorize @account
    @account.destroy
    redirect_to accounts_path
  end

  private

  def account_params
    params.require(:account).permit(:name, :url, :price_url, :description, :units, :price, :active)
  end
end
