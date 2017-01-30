require 'test_helper'

class MilestonesControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do

    it 'should not allow index access' do
      get milestones_path
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

    describe 'with a milestone' do

      before do
        @user_milestone = create(:milestone, person: @user)
      end

      after do
        @user_milestone.destroy if @user_milestone
      end

      it 'should get index' do
        get milestones_path
        assert_response :success
        assert_not_nil assigns(:milestones)
        assert_select 'span.list-title', 'milestones'
      end

      it 'should not allow editing of milestones belonging to others' do
        # create a milestone belonging to a new user
        another_milestone = create(:milestone)
        get milestone_path(another_milestone)
        assert_redirected_to root_url
        # clean up the new milestone and person
        another_milestone.person.destroy
      end

      it 'should get edit' do
        get edit_milestone_path(@user_milestone), xhr: true
        assert_response :success
        assert_select 'h3', /^update milestone.*/
      end

      it 'should update milestone' do
        put milestone_path(@user_milestone), xhr: true, params: { milestone: { name: 'foobar' } }
        assert_response :success
        @user_milestone.reload
        assert_equal 'foobar', @user_milestone.name
      end

      it 'should destroy milestone' do
        assert_difference('Milestone.count', -1) do
          delete milestone_path(@user_milestone)
        end
        assert_redirected_to milestones_path
      end
    end

    it 'should show the new milestone form' do
      get new_milestone_path, xhr: true
      assert_response :success
    end

    it 'should create milestone' do
      assert_difference('Milestone.count') do
        post milestones_path, xhr: true, params: { milestone: { person: @user, name: 'graduated', milestone_at: Time.now - 5.years } }
      end
      assert_response :success
    end

  end
end
