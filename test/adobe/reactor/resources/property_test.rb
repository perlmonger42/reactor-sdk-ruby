require "test_helper"

class Adobe::Reactor::PropertyTest < Minitest::Test

  def test_index
    properties = test_co.properties
    assert_equal properties.map(&:type_of).uniq, ['properties']
    assert_equal 'dummy', properties.first.company.name
    # format/data?
  end

#  def test_get_and_update
#    c1 = Adobe::Reactor::Property.get(@property_id)
#    old_name = c1.name
#    c1.name = c1.name.succ
#    c1.save
#    c2 = Adobe::Reactor::Property.get(@property_id)
#    refute_equal old_name, c2.name
#  end
#
#  def test_reload
#    c1 = Adobe::Reactor::Property.get(@property_id)
#    c2 = Adobe::Reactor::Property.get(@property_id)
#    c1.name = c1.name.succ
#    c1.save
#    c2.reload
#    assert_equal c1.name, c2.name
#    # TODO test reload relationships... ewww
#  end
#
#  def test_relationship_properties
#    c1 = Adobe::Reactor::Property.get(@property_id)
#    properties = c1.properties
#    assert_equal properties.map(&:type_of).uniq, ['properties']
#    # TODO pagination
#  end
end
