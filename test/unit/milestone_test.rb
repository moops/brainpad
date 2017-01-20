require 'test_helper'

class MilestoneTest < ActiveSupport::TestCase
  let(:adam) { Person.find_by(username: 'adam') }
  let(:next_week) { Milestone.create!(person: adam, name: 'tomorrow', milestone_at: Date.today + 7) }
  let(:tomorrow) { Milestone.create!(person: adam, name: 'tomorrow', milestone_at: Date.today + 1) }

  it 'fails to save without required fields' do
    ms = Milestone.new
    refute ms.save, 'saved without person'
    ms.person = adam

    refute ms.save, 'saved without name'
    ms.name = 'new milestone'

    refute ms.save, 'saved without milestone datetime'
    ms.milestone_at = Date.today

    assert ms.save, 'save with all required fields'
  end

  it 'finds the next milestone' do
    assert_equal tomorrow, Milestone.next_milestone(adam)
  end
end
