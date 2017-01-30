require 'test_helper'

class PaymentsControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do

    it 'should not allow index access' do
      get payments_path
      assert_redirected_to root_url
    end
  end

  describe 'authenticated' do

    before do
      @user = create(:person)
      login @user
    end

    after do
      @user.destroy
    end

    it 'should not show payments belonging to others' do
      # create a payment belonging to a new user
      another_payment = create(:payment)
      get payment_path(another_payment)
      assert_redirected_to root_url
      # clean up the new payment and person
      another_payment.person.destroy
    end

    describe 'with a payment' do

      before do
        @user_payment = create(:payment, person: @user)
      end

      after do
        @user_payment.destroy if @user_payment
      end

      it 'should get index' do
        get payments_path
        assert_response :success
        assert_not_nil assigns(:payments)
        assert_select 'span.list-title', 'transactions'
      end

      it 'should show payments belonging current user' do
        get payment_path(@user_payment), xhr: true
        assert_response :success
        assert_select 'h3', /^transaction details.*/
      end

      it 'should get edit' do
        get edit_payment_path(@user_payment), xhr: true
        assert_response :success
        assert_select 'h3', /^update payment.*/
      end

      it 'should update payment' do
        put payment_path(@user_payment), xhr: true, params: { payment: { description: 'new description', amount: 50 } }
        @user_payment.reload
        assert_equal 50, @user_payment.amount
        assert_equal 'new description', @user_payment.description
        assert_redirected_to payments_path
      end

      it 'should destroy payment' do
        assert_difference('Payment.count', -1) do
          delete payment_path(@user_payment)
        end
        assert_redirected_to payments_path
      end
    end

    it 'should show the new payment form' do
      get new_payment_path, xhr: true
      assert_response :success
    end

    it 'should create payment' do
      account = create(:account)
      assert_difference('Payment.count') do
        post payments_path, xhr: true, params: { payment: { person: @user, account: account, amount: 25, payment_on: Date.today } }
      end
      assert_redirected_to payments_path
    end
  end
end
