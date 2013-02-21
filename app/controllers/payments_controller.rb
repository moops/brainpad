class PaymentsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /payments
  def index
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

  # GET /payments/1
  # GET /payments/1.xml
  def show

    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment.amount = @payment.amount.abs
    get_stuff_for_form
    respond_to do |format|
      format.html 
      format.js { render :layout => false }
    end
  end

  # POST /payments
  # POST /payments.xml
  def create
    @payment.amount *= -1 if @payment.payment_type.eql?('expense')
    @payment.apply_to_account
    respond_to do |format|
      if @payment.save
        flash[:notice] = 'Payment was successfully created.'
        format.html { redirect_to(payments_path) }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        format.html { redirect_to(payments_path)  }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    new_amount = params[:payment][:amount].to_f
    logger.info("new_amount: #{new_amount}, payment type: #{params[:payment][:payment_type]}")
    new_amount = -new_amount if 'expense'.eql? params[:payment][:payment_type]
    logger.info("new_amount: #{new_amount}, payment type: #{params[:payment][:payment_type]}")
    logger.info("@payment: #{@payment.inspect}")
    @payment.update_amount_and_adjust_account(new_amount)
    logger.info("@payment: #{@payment.inspect}")
    params[:payment].delete('amount')
    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        flash[:notice] = 'Payment was successfully updated.'
        format.html { redirect_to(payments_path)  }
        format.xml  { head :ok }
      else
        format.html { redirect_to(payments_path) }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.xml
  def destroy
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to(payments_url) }
      format.xml  { head :ok }
    end
  end

private

  def get_stuff_for_form
    @payment_types = %w{ expense deposit transfer }
    @accounts = current_user.accounts.active
    @tags = Payment.user_tags(current_user)
  end
end