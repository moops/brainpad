class PaymentsController < ApplicationController
  
  before_filter :authorize
  layout 'standard.html', :except => :show
  
  # GET /payments
  # GET /payments.xml
  def index
    if params[:id]
      @payment = Payment.find(params[:id])
      @payment.amount = @payment.amount.abs
    else
      @payment = Payment.new
      @payment.payment_type = 'expense'
      @payment.payment_on = Date.today.strftime('%Y-%m-%d')
    end
    
    @upcoming_payments = Payment.find_upcoming(@user)
    @payments = Payment.paginate :page => params[:page], :conditions => "person_id = #{@user.id}", :order => 'payment_on desc', :per_page => 25
    get_stuff_for_form
    @money_summary = MoneySummary.new(@user,31)
    @expenses_by_tag = Payment.expenses_by_tag(@user,31)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.xml
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
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
    @payment = Payment.new(params[:payment])
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
    @payment = Payment.find(params[:id])
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
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to(payments_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    
    def get_stuff_for_form
      @payment_types = %w{ expense deposit transfer }
      @accounts = @user.active_accounts
      @tags = Payment.user_tags(@user)
  end
  
end

class MoneySummary

  attr_reader :buy_nothing_days, :net_change, :per_day, :days_with_expenses, :balance, :total

  def initialize(user,days)
    deposits = Payment.recent_deposits(user,days)
    income = 0
    for dep in deposits
      income += dep.amount
    end
    expenses = Payment.recent_expenses(user,days)
    @total = 0
    for exp in expenses
      @total += exp.amount.abs
    end
    @net_change = income - @total
    @per_day     = @total/days if days > 0
    @buy_nothing_days = days - Payment.days_with_expenses?(user,days)
    @balance = 0
    for account in user.active_accounts
      @balance += account.balance?
    end
  end
    
end
