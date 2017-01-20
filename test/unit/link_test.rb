require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }

  it 'fails to save without required fields' do
    link = Link.new
    refute link.save, 'saved without person'
    link.person = adam

    refute link.save, 'saved without url'
    link.url = 'www.nba.com'

    refute link.save, 'saved without name'
    link.name = 'nba'

    assert link.save, 'save with all required fields'
  end

end
