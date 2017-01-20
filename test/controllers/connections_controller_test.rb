require 'test_helper'

class ConnectionsControllerTest < ActionDispatch::IntegrationTest

  test 'should get index' do
    get :index, {}, { user_id: people(:adam).to_param }
    assert_response :success
    assert_not_nil assigns(:connections)
  end

  test "should create connection" do
    assert_difference('Connection.count') do
      post :create, {:connection => { :person => people(:adam), :username => 'moops', :password => 'foobar', :url => 'http://www.nba.com' }}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to connections_path
  end

  test "should show connection" do
    get :show, {:id => connections(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => connections(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should update connection" do
    put :update, {:id => connections(:one).to_param, :connection => { }}, {'user_id' => people(:adam).to_param}
    assert_redirected_to connections_path
  end

  test "should destroy connection" do
    assert_difference('Connection.count', -1) do
      delete :destroy, {:id => connections(:one).to_param}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to connections_path
  end
end
