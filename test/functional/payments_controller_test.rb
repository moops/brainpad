require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, {}, {'user_id' => people(:adam).to_param}
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post :create, {:payment => { :person => people(:adam), :account => accounts(:visa), :amount => 25, :payment_on => Date.today}}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to payment_path(assigns(:payment))
  end

  test "should show payment" do
    get :show, {:id => payments(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => payments(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should update payment" do
    put :update, {:id => payments(:one).to_param, :payment => { }}, {'user_id' => people(:adam).to_param}
    assert_redirected_to payment_path(assigns(:payment))
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete :destroy, {:id => payments(:one).to_param}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to payments_path
  end
end
