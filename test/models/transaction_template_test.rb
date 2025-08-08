require "test_helper"

class TransactionTemplateTest < ActiveSupport::TestCase
  test "alphabetically sorts by name" do
    family = families(:dylan_family)
    first = TransactionTemplate.create!(name: "Alpha", family: family)
    second = TransactionTemplate.create!(name: "Beta", family: family)
    assert_equal [first, second], TransactionTemplate.where(id: [first.id, second.id]).alphabetically
  end
end
