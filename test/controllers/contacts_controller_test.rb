require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest

  describe 'unauthenticated' do

    it 'should not allow index access' do
      get contacts_path
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

    it 'should not show contacts belonging to others' do
      # create a contact belonging to a new user
      another_contact = create(:contact)
      get contact_path(another_contact)
      assert_redirected_to root_url
      # clean up the new contact and person
      another_contact.person.destroy
    end

    describe 'with a contact' do

      before do
        @user_contact = create(:contact, person: @user)
      end

      after do
        @user_contact.destroy if @user_contact
      end

      it 'should get index' do
        get contacts_path
        assert_response :success
        assert_not_nil assigns(:contacts)
        assert_select 'span.list-title', 'contacts'
      end

      it 'should show contacts belonging current user' do
        get contact_path(@user_contact), xhr: true
        assert_response :success
        assert_select 'h5', /^contact details.*/
      end

      it 'should get edit' do
        get edit_contact_path(@user_contact), xhr: true
        assert_response :success
        assert_select 'h5', /^update contact.*/
      end

      it 'should update contact' do
        put contact_path(@user_contact), xhr: true, params: { contact: { name: 'foobar' } }
        assert_response :success
        @user_contact.reload
        assert_equal 'foobar', @user_contact.name
      end

      it 'should destroy contact' do
        assert_difference('Contact.count', -1) do
          delete contact_path(@user_contact)
        end
        assert_redirected_to contacts_path
      end
    end

    it 'should show the new contact form' do
      get new_contact_path, xhr: true
      assert_response :success
    end

    it 'should create contact' do
      assert_difference('Contact.count') do
        post contacts_path, xhr: true, params: { contact: { person: @user, name: 'darby', comments: 'good dog' } }
      end
      assert_response :success
    end
  end
end
