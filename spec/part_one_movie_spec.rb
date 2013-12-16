require 'spec_helper'
require 'nicoquery'
require 'fixtures/part_one_movies_from_20130901_to_20130905'
require 'fixtures/series_mylist/mylist_1001'
require 'fixtures/series_mylist/mylist_2001'
require 'fixtures/series_mylist/getthumbinfo_sm1001'
require 'fixtures/series_mylist/getthumbinfo_sm1002'
require 'fixtures/series_mylist/getthumbinfo_sm1003'
require 'fixtures/series_mylist/getthumbinfo_sm2001'
require 'fixtures/series_mylist/getthumbinfo_sm2002'
require 'fixtures/series_mylist/getthumbinfo_sm2003'
require 'fixtures/getthumbinfo_sm19528141'
require 'fixtures/getthumbinfo_deleted'
# sm17675606は、説明文中に以下の4つのマイリストを記載している。
# 31776968が、sm17675606を含むシリーズのマイリスト
require 'fixtures/mylist_31776968'
require 'fixtures/mylist_29776641'
require 'fixtures/mylist_30544641'
require 'fixtures/mylist_32098741'


describe PartOneMovie do
  describe "latest_archived_movie" do

    context "when movies are already stored in DB" do
      let!(:previous_movie_1) { FactoryGirl.create(:part_one_movie, publish_date: Time.local(2013, 8, 30, 0, 0, 0)) }
      let!(:previous_movie_2) { FactoryGirl.create(:part_one_movie, publish_date: Time.local(2013, 8, 31, 0, 0, 0)) }
      let!(:latest_movie) { FactoryGirl.create(:part_one_movie, publish_date: Time.local(2013, 9, 1, 0, 0, 0)) }

      before do
        @latest = PartOneMovie.latest_archived_movie
      end

      it "should acquire the movie that is latest published from DB" do
        expect(@latest.video_id).to eq latest_movie.video_id
      end
    end

    context "when there is no movie in DB" do
      before do
        @latest = PartOneMovie.latest_archived_movie
      end

      it "should return dummy object" do
        expect(@latest).to be_empty
      end
    end
  end

    # context "when target mylist contains no movie" do
    #   let!(:movie) { FactoryGirl.create(:part_one_movie,  video_id: 'sm99999001',
    #                                                       publish_date: Time.local(2013, 9, 1, 0, 0, 0),
    #                                                       mylist_references: "") }

    #   before do
    #     # TODO ?がURLの末尾に付くのは想定外なので、nicoqueryを修正する。
    #     WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm99999001?").
    #       with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
    #       to_return(:status => 200, :body => Fixture.getthumbinfo_sm99999001, :headers => {})

    #     # sm17675606の説明文に記載されたマイリストのURL
    #     WebMock.stub_request(:get, "http://www.nicovideo.jp/mylist/31776968?numbers=1&rss=2.0").
    #        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
    #        to_return(:status => 200, :body => Fixture.mylist_31776968, :headers => {})

    #     PartOneMovie.retrieve_series_mylist
    #   end

    #   subject { PartOneMovie.first }

    #   it "should retrieve series mylist" do
    #     expect(subject.series_mylist).to eq 31776968
    #   end
    # end

end
