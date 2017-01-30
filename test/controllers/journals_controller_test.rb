require 'test_helper'

class JournalsControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do
    it 'should not allow index access' do
      get journals_path
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

    it 'should not show journals belonging to others' do
       # create an entry belonging to a new user
      another_entry = create(:journal)
      get journal_path(another_entry)
      assert_redirected_to root_url
      # clean up the new entry and person
      another_entry.person.destroy
    end

    describe 'with an entry' do

      before do
        @user_entry = create(:journal, person: @user)
      end

      after do
        @user_entry.destroy if @user_entry
      end

      it 'should get index' do
        get journals_path
        assert_response :success
        assert_not_nil assigns(:journals)
        assert_select 'span.list-title', 'entries'
      end

      it 'should show journals belonging current user' do
        get journal_path(@user_entry), xhr: true
        assert_response :success
        assert_select 'h3', /^entry details.*/
      end

      it 'should get edit' do
        get edit_journal_path(@user_entry), xhr: true
        assert_response :success
        assert_select 'h3', /^update journal.*/
      end

      it 'should update journal' do
        put journal_path(@user_entry), xhr: true, params: { journal: { entry: 'foobar' } }
        assert_response :success
        @user_entry.reload
        assert_equal 'foobar', @user_entry.entry
      end

      it 'should destroy journal' do
        assert_difference('Journal.count', -1) do
          delete journal_path(@user_entry)
        end
        assert_redirected_to journals_path
      end
    end

    it 'should show the new entry form' do
      get new_journal_path, xhr: true
      assert_response :success
    end

    it 'should create journal' do
      assert_difference('Journal.count') do
        post journals_path, xhr: true, params: { journal: { person: @user, entry: 'test entry', entry_on: Date.today - 2 } }
      end
      assert_response :success
    end
  end
end
