require 'spec_helper'

describe "mylist_logs/index" do
  before(:each) do
    assign(:mylist_logs, [
      stub_model(MylistLog,
        :mylist_id => 1,
        :amount_of_view => 2,
        :amount_of_mylist => 3,
        :amount_of_comment => 4
      ),
      stub_model(MylistLog,
        :mylist_id => 1,
        :amount_of_view => 2,
        :amount_of_mylist => 3,
        :amount_of_comment => 4
      )
    ])
  end

  it "renders a list of mylist_logs" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
