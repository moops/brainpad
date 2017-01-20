require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }

  it 'fails to save without required fields' do
    con = Connection.new
    refute con.save, 'saved without person'
    con.person = adam

    refute con.save, 'saved without username'
    con.username = 'gmail'

    refute con.save, 'saved without password'
    con.password = 'quinn'

    refute con.save, 'saved without url'
    con.url = 'www.investorsgroup.ca'

    assert con.save, 'save with all required fields'
  end
end
