class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show edit update destroy]

  # GET /payments
  def index
    authorize Payment
    @payments = current_user.payments.where(:payment_on.gt => 1.year.ago).desc(:payment_on)
    @accounts = current_user.accounts.active
    @payments = @payments.where(description: /#{params[:q]}/i) if params[:q]
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
    authorize @payment
  end

  # GET /payments/new.js
  def new
    @payment = params[:payment_id] ? Payment.find(params[:payment_id]).dup : Payment.new
    authorize @payment
    stuff_for_form
    @payment = Payment.find(params[:payment_id]).dup if params[:payment_id]
  end

  # GET /payments/1/edit.js
  def edit
    authorize @payment
    stuff_for_form
  end

  # POST /payments
  def create
    @payment = current_user.payments.build(payment_params)
    authorize @payment
    if @payment.save
      @payment.apply
      current_user.tag('payment', @payment.tags)
      flash[:notice] = 'payment was created.'
      redirect_to payments_path
    end
  end

  # PUT /payments/1
  def update
    authorize @payment
    new_amount = params[:payment][:amount].to_f
    @payment.update_amount_and_adjust_account(new_amount)
    params[:payment].delete('amount')
    params[:payment][:from_account] = Account.find(params[:payment][:from_account]) if params[:payment][:from_account].present?
    params[:payment][:to_account] = Account.find(params[:payment][:to_account]) if params[:payment][:to_account].present?
    params[:payment][:frequency] = Lookup.find(params[:payment][:frequency]) if params[:payment][:frequency].present?

    if @payment.update_attributes(payment_params)
      current_user.tag('payment', @payment.tags)
      flash[:notice] = 'payment was updated.'
      redirect_to payments_path
    end
  end

  # DELETE /payments/1
  def destroy
    authorize @payment
    @payment.apply(true)
    @payment.destroy
    redirect_to payments_path
  end

  private

  def stuff_for_form
    @accounts = current_user.accounts.active.order_by(name: :asc)
    @frequencies = Lookup.where(category: 36).all
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :description, :tags, :payment_on, :until, :from_account, :to_account, :frequency)
  end
end
