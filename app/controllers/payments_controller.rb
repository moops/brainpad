class PaymentsController < ApplicationController

  load_and_authorize_resource

  # GET /payments
  def index
    @payments = current_user.payments.desc(:payment_on)
    if params[:q]
      @payments = @payments.where(description: /#{params[:q]}/i)
    end
    if params[:tag]
      @payments = @payments.where(tags: /#{params[:tag]}/)
      @tag = params[:tag]
    end
    @payments = @payments.page(params[:page])

    @upcoming_payments = Payment.upcoming(current_user)
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
    @payment = current_user.payments.build(params[:payment])
    if @payment.save
      @payment.apply
      current_user.tag('payment', @payment.tags)
      flash[:notice] = 'payment was created.'
      redirect_to payments_path
    end
  end

  # PUT /payments/1
  def update
    @payment = current_user.payments.find(params[:id])
    new_amount = params[:payment][:amount].to_f
    @payment.update_amount_and_adjust_account(new_amount)
    params[:payment].delete('amount')
    params[:payment][:from_account] = Account.find(params[:payment][:from_account]) unless params[:payment][:from_account].empty?
    params[:payment][:to_account] = Account.find(params[:payment][:to_account]) unless params[:payment][:to_account].empty?
    params[:payment][:frequency] = Lookup.find(params[:payment][:frequency]) unless params[:payment][:frequency].empty?
    if @payment.update_attributes(params[:payment])
      current_user.tag('payment', @payment.tags)
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
    @tags = current_user.tags_for('payments')
  end
end