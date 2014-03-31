require 'spec_helper'

describe "mylist_logs/edit" do
  before(:each) do
    @mylist_log = assign(:mylist_log, stub_model(MylistLog,
      :mylist_id => 1,
      :amount_of_view => 1,
      :amount_of_mylist => 1,
      :amount_of_comment => 1
    ))
  end

  it "renders the edit mylist_log form" do
    render

    assert_select "form[action=?][method=?]", mylist_log_path(@mylist_log), "post" do
      assert_select "input#mylist_log_mylist_id[name=?]", "mylist_log[mylist_id]"
      assert_select "input#mylist_log_amount_of_view[name=?]", "mylist_log[amount_of_view]"
      assert_select "input#mylist_log_amount_of_mylist[name=?]", "mylist_log[amount_of_mylist]"
      assert_select "input#mylist_log_amount_of_comment[name=?]", "mylist_log[amount_of_comment]"
    end
  end
end
