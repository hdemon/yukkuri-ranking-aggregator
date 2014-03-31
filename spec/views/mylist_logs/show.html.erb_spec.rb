require 'spec_helper'

describe "mylist_logs/show" do
  before(:each) do
    @mylist_log = assign(:mylist_log, stub_model(MylistLog,
      :mylist_id => 1,
      :amount_of_view => 2,
      :amount_of_mylist => 3,
      :amount_of_comment => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
