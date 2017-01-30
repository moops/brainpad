require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do

    it 'should not allow edit access' do
      someone = create(:person)
      get edit_person_path(someone)
      assert_redirected_to root_url
    end

    it 'allows signup' do
      get new_person_path, xhr: true
      assert_response :success
      assert_select 'h3', /^sign up.*/
    end

    it 'creates a new person' do
      assert_difference('Person.count') do
        post people_path, params: { person: { username: 'testuser', email: 'test@raceweb.ca', password: 'foobar', password_confirmation: 'foobar' } }
      end
      # clean up
      Person.find_by(username: 'testuser').destroy
      assert_redirected_to links_path
    end
  end

  describe 'user authenticated' do

    before do
      @user = create(:person)
      login @user
    end

    after do
      @user.destroy
    end

    it 'allows signup' do
      get new_person_path, xhr: true
      assert_response :success
      assert_select 'h3', /^sign up.*/
    end

    it 'denies editing of others' do
      other = create(:person)
      get edit_person_path(other), xhr: true
      assert_select 'div', /.*You are not authorized to perform this action.*/
    end

    it 'allows editing of current user' do
      get edit_person_path(@user), xhr: true
      assert_response :success
      assert_select 'h3', /^update profile.*/
    end

    it 'updates current user' do
      put person_path(@user), params: { person: { phone: '123-456-7890' } }
      @user.reload
      assert_equal '123-456-7890', @user.phone
      assert_redirected_to links_path
    end

    it 'does not allow destroy current user' do
      assert_difference('Person.count', 0) do
        delete person_path(@user)
      end
      assert_redirected_to root_url
    end

    it 'does not allow destroy another user' do
      other = create(:person)
      assert_difference('Person.count', 0) do
        delete person_path(other)
      end
      assert_redirected_to root_url
    end
  end

  describe 'admin authenticated' do

    before do
      @admin = create(:person, :admin)
      @other = create(:person)
      login @admin
    end

    after do
      @admin.destroy
      @other.destroy if @other
    end

    it 'allows editing of other user' do
      get edit_person_path(@other), xhr: true
      assert_response :success
      assert_select 'h3', /^update profile.*/
    end

    it 'allows admin to destroy another user' do
      assert_difference('Person.count', -1) do
        delete person_path(@other)
      end
      assert_redirected_to root_url
    end
  end
end
