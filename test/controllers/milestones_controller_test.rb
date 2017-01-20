require 'test_helper'

class MilestonesControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, {}, {'user_id' => people(:adam).to_param}
    assert_response :success
    assert_not_nil assigns(:milestones)
  end

  test "should create milestone" do
    assert_difference('Milestone.count') do
      post :create, {:milestone => { :person => people(:adam), :milestone_at => Time.now, :name => 'finished this test' }}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to milestones_path
  end

  test "should show milestone" do
    get :show, {:id => Milestone(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => Milestone(:one).to_param}, {'user_id' => people(:adam).to_param}
    assert_response :success
  end

  test "should update milestone" do
    put :update, {:id => Milestone(:one).to_param, :link => { }}, {'user_id' => people(:adam).to_param}
    assert_redirected_to milestones_path
  end

  test "should destroy milestone" do
    assert_difference('Milestone.count', -1) do
      delete :destroy, {:id => milestones(:one).to_param}, {'user_id' => people(:adam).to_param}
    end

    assert_redirected_to milestones_path
  end
end
