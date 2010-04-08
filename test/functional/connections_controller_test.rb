require 'test_helper'

class ConnectionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:connections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create connection" do
    assert_difference('Connection.count') do
      post :create, :connection => { }
    end

    assert_redirected_to connection_path(assigns(:connection))
  end

  test "should show connection" do
    get :show, :id => connections(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => connections(:one).to_param
    assert_response :success
  end

  test "should update connection" do
    put :update, :id => connections(:one).to_param, :connection => { }
    assert_redirected_to connection_path(assigns(:connection))
  end

  test "should destroy connection" do
    assert_difference('Connection.count', -1) do
      delete :destroy, :id => connections(:one).to_param
    end

    assert_redirected_to connections_path
  end
end
