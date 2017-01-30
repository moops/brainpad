require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest

  before do
    @user = create(:person)
    @chequing = create(:account, name: 'chequing', person: @user)
    login @user
  end

  after do
    @user.destroy
    @chequing.destroy if @chequing
  end

  it 'shows new form' do
    get new_account_path, xhr: true
    assert_response :success
  end

  it 'creates an account' do
    assert_difference('Account.count') do
      post accounts_path, params: { account: { person: @user, name: 'new account', description: 'new account desc', units: 100, price: 1 } }
    end
    assert_redirected_to accounts_path
  end

  it 'should get edit' do
    get edit_account_path(@chequing), xhr: true
    assert_response :success
  end

  it 'should update account' do
    put account_path(@chequing), params: { account: { person: @user, name: 'chequing2' } }
    assert_redirected_to accounts_path
  end

  it 'should destroy account' do
    assert_difference('Account.count', -1) do
      delete account_path(@chequing)
    end
    assert_redirected_to accounts_path
  end
end
