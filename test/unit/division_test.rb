# encoding: utf-8
require_relative '../test_helper'

class DivisionTest < ActiveSupport::TestCase
  
  should "return the slug" do
    assert_equal 'a-slug', Calendar::Division.new('a-slug', {}).slug
  end

  should "return the slug for to_param" do
    assert_equal 'a-slug', Calendar::Division.new('a-slug', {}).to_param
  end

  context "title" do
    should "return the title from the data if given" do
      d = Calendar::Division.new('a-slug', {"title" => "something"})
      assert_equal 'something', d.title
    end

    should "humanize the slug otherwise" do
      d = Calendar::Division.new('a-slug', {})
      assert_equal 'A slug', d.title
    end
  end

  context "years" do
    setup do
      @div = Calendar::Division.new('something', {
        "title" => "A Division",
        "2012" => [1,2],
        "2013" => [3,4],
      })
    end

    should "construct a year for each one in the data" do
      div = Calendar::Division.new('something', {
        "2012" => [1,2],
        "2013" => [3,4],
      })
      Calendar::Year.expects(:new).with("2012", [1,2]).returns(:y_2012)
      Calendar::Year.expects(:new).with("2013", [3,4]).returns(:y_2013)

      assert_equal [:y_2012, :y_2013], div.years
    end

    should "cache the constructed instances" do
      div = Calendar::Division.new('something', {
        "2012" => [1,2],
        "2013" => [3,4],
      })

      first = div.years
      Calendar::Year.expects(:new).never
      assert_equal first, div.years
    end

    should "ignore non-year keys in the data" do
      div = Calendar::Division.new('something', {
        "title" => "A Thing",
        "2012" => [1,2],
        "2013" => [3,4],
        "foo" => "bar",
      })

      Calendar::Year.stubs(:new).with("2012", [1,2]).returns(:y_2012)
      Calendar::Year.stubs(:new).with("2013", [3,4]).returns(:y_2013)
      Calendar::Year.expects(:new).with("title", anything).never
      Calendar::Year.expects(:new).with("foo", anything).never

      assert_equal [:y_2012, :y_2013], div.years
    end
  end

  context "upcoming event" do
    setup do
      @years = []
      @div = Calendar::Division.new('something')
      @div.stubs(:years).returns(@years)
    end

    should "return nil with no years" do
      assert_equal nil, @div.upcoming_event
    end

    should "return nil if no years have upcoming_events" do
      @years << stub("Year1", :upcoming_event => nil)
      @years << stub("Year2", :upcoming_event => nil)
      assert_equal nil, @div.upcoming_event
    end

    should "return the upcoming event for the first year that has one" do
      @years << stub("Year1", :upcoming_event => nil)
      @years << stub("Year2", :upcoming_event => :event_1)
      @years << stub("Year3", :upcoming_event => :event_2)

      assert_equal :event_1, @div.upcoming_event
    end

    should "cache the event" do
      y1 = stub("Year1")
      y2 = stub("Year2", :upcoming_event => :event_1)
      @years << y1
      @years << y2

      y1.expects(:upcoming_event).once.returns(nil)
      @div.upcoming_event
      assert_equal :event_1, @div.upcoming_event
    end
  end
end
