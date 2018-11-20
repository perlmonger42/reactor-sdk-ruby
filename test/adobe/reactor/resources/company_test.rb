require "test_helper"

class Adobe::Reactor::CompanyTest < Minitest::Test

  def setup
    @company_id = ENV['REACTOR_TEST_COMPANY_ID'] || 'CO958848cd700e44fa93dd5ab0f1a11dd3'
  end

  def test_index
    companies = Adobe::Reactor::Company.index
    refute_empty companies
    # format/data?
  end

  def test_get_and_update
    c1 = Adobe::Reactor::Company.get(@company_id)
    old_name = c1.name
    c1.name = c1.name.succ
    c1.save
    c2 = Adobe::Reactor::Company.get(@company_id)
    refute_equal old_name, c2.name
  end

  def test_reload
    c1 = Adobe::Reactor::Company.get(@company_id)
    c2 = Adobe::Reactor::Company.get(@company_id)
    c1.name = c1.name.succ
    c1.save
    c2.reload
    assert_equal c1.name, c2.name
  end
end
