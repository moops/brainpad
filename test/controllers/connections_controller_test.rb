require 'test_helper'

class ConnectionsControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do

    it 'should not allow index access' do
      get connections_url
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

    it 'should not show connections belonging to others' do
      # create a connection belonging to a new user
      another_connection = create(:connection)
      get connection_path(another_connection)
      assert_redirected_to root_url
      # clean up the new connection and person
      another_connection.person.destroy
    end

    describe 'with a connection' do

      before do
        @user_connection = create(:connection, person: @user)
      end

      after do
        @user_connection.destroy if @user_connection
      end

      it 'should get index' do
        get connections_url
        assert_response :success
        assert_not_nil assigns(:connections)
        assert_select 'span', 'connections'
      end

      it 'should show connections belonging current user' do
        get connection_path(@user_connection), xhr: true
        assert_response :success
        assert_select 'h5', /^connection details.*/
      end

      it 'should get edit' do
        get edit_connection_path(@user_connection), xhr: true
        assert_response :success
        assert_select 'h5', /^update connection.*/
      end

      it 'should update connection' do
        put connection_path(@user_connection), xhr: true, params: { connection: { name: 'foobar' } }
        assert_response :success
        @user_connection.reload
        assert_equal 'foobar', @user_connection.name
      end

      it 'should destroy connection' do
        assert_difference('Connection.count', -1) do
          delete connection_path(@user_connection)
        end
        assert_redirected_to connections_path
      end
    end

    it 'should show the new connection form' do
      get new_connection_path, xhr: true
      assert_response :success
    end

    it 'should create connection' do
      assert_difference('Connection.count') do
        post connections_path, xhr: true, params: { connection: { person: @user, username: 'qball', password: 'foobar', url: 'http://www.example.com' } }
      end
      assert_response :success
      # clean up
      @user.connections.find_by(username: 'qball').destroy
    end
  end
end
