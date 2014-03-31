require 'spec_helper'

describe "mylist_logs/new" do
  before(:each) do
    assign(:mylist_log, stub_model(MylistLog,
      :mylist_id => 1,
      :amount_of_view => 1,
      :amount_of_mylist => 1,
      :amount_of_comment => 1
    ).as_new_record)
  end

  it "renders new mylist_log form" do
    render

    assert_select "form[action=?][method=?]", mylist_logs_path, "post" do
      assert_select "input#mylist_log_mylist_id[name=?]", "mylist_log[mylist_id]"
      assert_select "input#mylist_log_amount_of_view[name=?]", "mylist_log[amount_of_view]"
      assert_select "input#mylist_log_amount_of_mylist[name=?]", "mylist_log[amount_of_mylist]"
      assert_select "input#mylist_log_amount_of_comment[name=?]", "mylist_log[amount_of_comment]"
    end
  end
end
