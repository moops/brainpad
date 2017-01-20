require 'test_helper'

class LinksControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, {}, {'user_id' => people(:adam).to_param}
    assert_response :success
    assert_not_nil assigns(:links)
  end

  test "should create link" do
    assert_difference('Link.count') do
      post :create, { :link => { :person => people(:adam), :url => 'http://www.nba.com', :name => 'nba' }}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to links_path
  end

  test "should show link" do
    get :show, { :id => links(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, { :id => links(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should update link" do
    put :update, { :id => links(:one).to_param, :link => { }}, {'user_id' => people(:adam).to_param}
    assert_redirected_to links_path
  end

  test "should destroy link" do
    assert_difference('Link.count', -1) do
      delete :destroy, { :id => links(:one).to_param}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to links_path
  end
end
