require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }

  it 'fails to save without required fields' do
    con = Contact.new
    refute con.save, 'saved without person'
    con.person = adam

    refute con.save, 'saved without name'
    con.name = 'fred flintstone'

    assert con.save, 'save with all required fields'
  end
end
