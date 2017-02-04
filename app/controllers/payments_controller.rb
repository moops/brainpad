class PaymentsController < ApplicationController

  # GET /payments
  def index
    authorize Payment
    @payments = current_user.payments.where(:payment_on.gt => 1.year.ago).desc(:payment_on)
    @accounts = current_user.accounts.active
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
    @payment = Payment.find(params[:id])
    authorize @payment
  end

  # GET /payments/new.js
  def new
    @payment = (params[:payment_id]) ? Payment.find(params[:payment_id]).dup : Payment.new
    authorize @payment
    get_stuff_for_form
    if (params[:payment_id])
      @payment = Payment.find(params[:payment_id]).dup
    end
  end

  # GET /payments/1/edit.js
  def edit
    @payment = Payment.find(params[:id])
    authorize @payment
    get_stuff_for_form
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
    @payment = Payment.find(params[:id])
    authorize @payment
    new_amount = params[:payment][:amount].to_f
    @payment.update_amount_and_adjust_account(new_amount)
    params[:payment].delete('amount')
    params[:payment][:from_account] = Account.find(params[:payment][:from_account]) unless params[:payment][:from_account].blank?
    params[:payment][:to_account] = Account.find(params[:payment][:to_account]) unless params[:payment][:to_account].blank?
    params[:payment][:frequency] = Lookup.find(params[:payment][:frequency]) unless params[:payment][:frequency].blank?

    if @payment.update_attributes(payment_params)
      current_user.tag('payment', @payment.tags)
      flash[:notice] = 'payment was updated.'
      redirect_to payments_path
    end
  end

  # DELETE /payments/1
  def destroy
    @payment = Payment.find(params[:id])
    authorize @payment
    @payment.apply(true)
    @payment.destroy
    redirect_to payments_path
  end

  private

  def get_stuff_for_form
    @accounts = current_user.accounts.active.order_by(name: :asc)
    @frequencies = Lookup.where(category: 36).all
  end

  private

  def payment_params
    params.require(:payment).permit(:amount, :description, :tags, :payment_on, :until, :from_account, :to_account, :frequency)
  end
end
