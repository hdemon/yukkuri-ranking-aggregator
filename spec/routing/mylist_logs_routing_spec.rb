require "spec_helper"

describe MylistLogsController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/mylist_logs").to route_to("mylist_logs#index")
    end

    it "routes to #new" do
      expect(:get => "/mylist_logs/new").to route_to("mylist_logs#new")
    end

    it "routes to #show" do
      expect(:get => "/mylist_logs/1").to route_to("mylist_logs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/mylist_logs/1/edit").to route_to("mylist_logs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/mylist_logs").to route_to("mylist_logs#create")
    end

    it "routes to #update" do
      expect(:put => "/mylist_logs/1").to route_to("mylist_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/mylist_logs/1").to route_to("mylist_logs#destroy", :id => "1")
    end

  end
end
