require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, {}, {'user_id' => people(:adam).to_param}
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, {:contact => { :person => people(:adam), :name => 'scooby do' }}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to contacts_path
  end

  test "should show contact" do
    get :show, {:id => contacts(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => contacts(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should update contact" do
    put :update, {:id => contacts(:one).to_param, :contact => { }}, {'user_id' => people(:adam).to_param}
    assert_redirected_to contacts_path
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, {:id => contacts(:one).to_param}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to contacts_path
  end
end
