class PaymentsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /payments
  def index
    session[:payment_tags] = get_unique_tags
    @payments = current_user.payments.desc(:payment_on)
    if params[:q]
      @payments = @payments.where(name: /#{params[:q]}/i)
    end
    if params[:tag]
      @payments = @payments.where(tags: /#{params[:tag]}/)
      flash[:notice] = "showing only #{params[:tag]} payments."
      @tag = params[:tag]
    end
    @payments = @payments.page(params[:page])
  
    @upcoming_payments = Payment.upcoming(current_user)
    get_stuff_for_form
    @money_summary = Payment.summary(current_user, 31)
    @expenses_by_tag = Payment.expenses_by_tag(current_user, 31)
  end

  # GET /payments/1.js
  def show
  end
  
  # GET /payments/new.js
  def new
    get_stuff_for_form
    if (params[:payment_id])
      @payment = Payment.find(params[:payment_id]).dup
    end
  end

  # GET /payments/1/edit.js
  def edit
    get_stuff_for_form
  end

  # POST /payments
  def create
    @payment.apply
    if @payment.save
      flash[:notice] = 'payment was created.'
      redirect_to payments_path
    end
  end

  # PUT /payments/1
  def update
    new_amount = params[:payment][:amount].to_f
    @payment.update_amount_and_adjust_account(new_amount)
    params[:payment].delete('amount')
    if @payment.update_attributes(params[:payment])
      flash[:notice] = 'payment was updated.'
      redirect_to payments_path
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.apply(true)
    @payment.destroy
    redirect_to payments_path
  end

  private

  def get_stuff_for_form
    @accounts = current_user.accounts.active
    @frequencies = Lookup.where(category: 36).all
    @tags = Payment.user_tags(current_user)
  end
  
  private

  def get_unique_tags
    unique_tags = []
    current_user.payments.each do |payment|
      if payment.tags
        payment.tags.split.each do |tag|
          unique_tags.push(tag.strip)
        end
      end
    end
    unique_tags.uniq.sort unless unique_tags.empty?
  end
end