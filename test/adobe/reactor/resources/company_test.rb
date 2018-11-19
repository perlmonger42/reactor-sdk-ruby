require "test_helper"

class Adobe::Reactor::CompanyTest < Minitest::Test

  def test_index
    companies = Adobe::Reactor::Company.index('http://localhost:9010/companies')
    refute_empty companies
    # format/data?
  end

  def test_get_and_update
    c1 = Adobe::Reactor::Company.get('http://localhost:9010/companies/CO958848cd700e44fa93dd5ab0f1a11dd3')
    old_name = c1.name
    c1.name = c1.name.succ
    c1.save
    c2 = Adobe::Reactor::Company.get('http://localhost:9010/companies/CO958848cd700e44fa93dd5ab0f1a11dd3')
    refute_equal old_name, c2.name
  end
end
