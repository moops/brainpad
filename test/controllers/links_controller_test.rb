require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do

    it 'should not allow index access' do
      get links_path
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

    it 'should not allow editing of links belonging to others' do
      # create a link belonging to a new user
      another_link = create(:link)
      get edit_link_path(another_link)
      assert_redirected_to root_url
      # clean up the new link and person
      another_link.person.destroy
    end

    describe 'with a link' do

      before do
        @user_link = create(:link, person: @user)
      end

      after do
        @user_link.destroy if @user_link
      end

      it 'should get index' do
        get links_path
        assert_response :success
        assert_not_nil assigns(:links)
        assert_select 'h4', 'often'
      end

      it 'should get edit' do
        get edit_link_path(@user_link), xhr: true
        assert_response :success
        assert_select 'form'
      end

      it 'should update link' do
        put link_path(@user_link), xhr: true, params: { link: { name: 'foobar' } }
        @user_link.reload
        assert_equal 'foobar', @user_link.name
        assert_redirected_to links_path
      end

      it 'should destroy link' do
        assert_difference('Link.count', -1) do
          delete link_path(@user_link)
        end
        assert_redirected_to links_path
      end
    end

    it 'should show the new link form' do
      get new_link_path, xhr: true
      assert_response :success
    end

    it 'should create link' do
      assert_difference('Link.count') do
        post links_path, xhr: true, params: { link: { person: @user, url: 'http://www.nba.com', name: 'nba' } }
      end
      assert_redirected_to links_path
    end

  end
end

