require 'test_helper'

class JournalsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, {}, {'user_id' => people(:adam).to_param}
    assert_response :success
    assert_not_nil assigns(:journals)
  end

  test "should create journal" do
    assert_difference('Journal.count') do
      post :create, { :journal => { :person => people(:adam), :entry => 'test entry', :entry_on => Date.today }}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to journals_path
  end

  test "should show journal" do
    get :show, { :id => journals(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, { :id => journals(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should update journal" do
    put :update, { :id => journals(:one).to_param, :journal => { }}, {'user_id' => people(:adam).to_param}
    assert_redirected_to journals_path
  end

  test "should destroy journal" do
    assert_difference('Journal.count', -1) do
      delete :destroy, { :id => journals(:one).to_param}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to journals_path
  end
end
