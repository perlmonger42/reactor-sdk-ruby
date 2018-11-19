require "test_helper"

class Adobe::ReactorUtilsTest < Minitest::Test
  def test_camelize
    cases = [
      ['a_thing', 'AThing'],
      ['thing', 'Thing'],
      ['a_b_c', 'ABC'],
      ['x', 'X'],
      ['X', 'X'],
      ['A_B_C', 'ABC'],
      ['DataElement', 'DataElement'],
      [:DataElement, 'DataElement'],
      [:data_element, 'DataElement'],
      [Adobe::Reactor::Company, 'Adobe::Reactor::Company'],
    ]
    assert_cases(cases, :camelize)
  end

  def test_classify
    cases = [
      ['company.property', 'Property'],
      ['company.properties', 'Property'],
      ['user.company.properties', 'Property'],
      ['company.private_property', 'PrivateProperty'],
      ['A::B::Company', 'A::B::Company'],
      [Adobe::Reactor::Company, 'Adobe::Reactor::Company'],
    ]
    assert_cases(cases, :classify)
  end

  def test_demodulize
    cases = [
      ['A::B::Company', 'Company'],
      ['::B::Company', 'Company'],
      ['B::Company', 'Company'],
      ['::Company', 'Company'],
      ['Company', 'Company'],
      [Adobe::Reactor::Company, 'Company'],
    ]
    assert_cases(cases, :demodulize)
  end

  def test_hash_with_indifferent_access
    h = Adobe::Reactor::Utils.hash_with_indifferent_access('x': 1)
    assert_equal 1, h['x']
    assert_equal 1, h[:x]

    h = Adobe::Reactor::Utils.hash_with_indifferent_access(y: 2)
    assert_equal 2, h['y']
    assert_equal 2, h[:y]

    h[:z] = 3
    assert_equal 3, h[:z]
    assert_equal 3, h['z']

    h['a'] = 4
    assert_equal 4, h[:a]
    assert_equal 4, h['a']

    h = Adobe::Reactor::Utils.hash_with_indifferent_access(y: {z: 5})
    assert_equal 5, h[:y][:z]
    assert_equal 5, h['y']['z']

    h = Adobe::Reactor::Utils.hash_with_indifferent_access(y: [{z: 6}])
    assert_equal 6, h[:y].first[:z]
    assert_equal 6, h['y'].first['z']
  end

  def test_pluralize
    cases = [
      ['Company', 'Companies'],
      ['rule', 'rules'],
      ['library', 'libraries'],
      ['data_element', 'data_elements'],
    ]
    assert_cases(cases, :pluralize)
  end

  def test_singularize
    cases = [
      ['Company', 'Companies'],
      ['rule', 'rules'],
      ['library', 'libraries'],
      ['data_element', 'data_elements'],
    ]
    assert_cases(cases.map(&:reverse), :singularize)
  end

  def test_tableize
    cases = [
      ['Company', 'companies'],
      [Adobe::Reactor::Company, 'companies'],
      ['rule', 'rules'],
      ['library', 'libraries'],
      ['DataElement', 'data_elements'],
    ]
    assert_cases(cases, :tableize)
  end

  def test_underscore
    cases = [
      ['Company', 'company'],
      [Adobe::Reactor::Company, 'adobe/reactor/company'],
      ['Adobe-Reactor-Company', 'adobe_reactor_company'],
      ['Rule', 'rule'],
      ['Library', 'library'],
      ['DataElement', 'data_element'],
      ['AThing', 'a_thing'],
      ['AAThing', 'aa_thing'],
      ['a7Thing', 'a7_thing'],
      ['FIVE7FIVE', 'five7_five'],
      ['7FiveFive', '7_five_five'],
    ]
    assert_cases(cases, :underscore)
  end

  private

  def assert_cases(cases, method_name)
    cases.each do |input, expectation|
      assert_equal expectation, Adobe::Reactor::Utils.send(method_name, input)
    end
  end
end
