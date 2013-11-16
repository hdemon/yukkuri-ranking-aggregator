require 'spec_helper'
require 'nicoquery'
require 'fixtures/part_one_movies_from_20130901_to_20130905'
require 'fixtures/getthumbinfo_sm17675606'
# sm17675606は、説明文中に以下の4つのマイリストを記載している。
# 31776968が、sm17675606を含むシリーズのマイリスト
require 'fixtures/mylist_31776968'
require 'fixtures/mylist_29776641'
require 'fixtures/mylist_30544641'
require 'fixtures/mylist_32098741'


describe PartOneMovie do
  describe ".get_latest_archived_movie" do

    context "when movies are already stored in DB" do
      let!(:previous_movie_1) { FactoryGirl.create(:part_one_movie, publish_date: Time.local(2013, 8, 30, 0, 0, 0)) }
      let!(:previous_movie_2) { FactoryGirl.create(:part_one_movie, publish_date: Time.local(2013, 8, 31, 0, 0, 0)) }
      let!(:latest_movie) { FactoryGirl.create(:part_one_movie, publish_date: Time.local(2013, 9, 1, 0, 0, 0)) }

      before do
        @latest = PartOneMovie.get_latest_archived_movie
      end

      it "should acquire the movie that is latest published from DB" do
        expect(@latest.video_id).to eq latest_movie.video_id
      end
    end

    context "when there is no movie in DB" do
      before do
        @latest = PartOneMovie.get_latest_archived_movie
      end

      it "should return dummy object" do
        expect(@latest).to be_nil
      end
    end
  end

  describe ".acquire_latest_movie" do
    context "suppose that it is 2013/9/5 23:59:59 and already acquired movies published until 2013/8/31 23:59:59" do
      let!(:latest_movie) { FactoryGirl.create(:part_one_movie, publish_date: Time.local(2013, 8, 31, 23, 59, 59)) }

      before do
        # first page
        WebMock.stub_request(:get, "http://www.nicovideo.jp/tag/%E3%82%86%E3%81%A3%E3%81%8F%E3%82%8A%E5%AE%9F%E6%B3%81%E3%83%97%E3%83%AC%E3%82%A4part1%E3%83%AA%E3%83%B3%E3%82%AF%20or%20VOICEROID%E5%AE%9F%E6%B3%81%E3%83%97%E3%83%AC%E3%82%A4Part1%E3%83%AA%E3%83%B3%E3%82%AF?numbers=1&order=d&page=1&rss=2.0&sort=f").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.part_one_movies_from_20130901_to_20130905_page1, :headers => {})

        # second page
        WebMock.stub_request(:get, "http://www.nicovideo.jp/tag/%E3%82%86%E3%81%A3%E3%81%8F%E3%82%8A%E5%AE%9F%E6%B3%81%E3%83%97%E3%83%AC%E3%82%A4part1%E3%83%AA%E3%83%B3%E3%82%AF%20or%20VOICEROID%E5%AE%9F%E6%B3%81%E3%83%97%E3%83%AC%E3%82%A4Part1%E3%83%AA%E3%83%B3%E3%82%AF?numbers=1&order=d&page=2&rss=2.0&sort=f").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.part_one_movies_from_20130901_to_20130905_page2, :headers => {})

        PartOneMovie.acquire_latest_movie
      end

      it "should acquire part one movie from 2013/9/1 0:00:00 to 2013/9/5 23:59:59 and storage them to DB" do
        movies = PartOneMovie.order(:publish_date)
        # movies.first is 'latest_movie'
        expect(movies.second.publish_date).to be > latest_movie.publish_date
      end
    end
  end

  describe ".retrieve_series_mylist" do
    let!(:movie) { FactoryGirl.create(:part_one_movie,  video_id: 'sm17675606',
                                                        publish_date: Time.local(2013, 9, 1, 0, 0, 0),
                                                        mylist_references: "31776968 29776641 30544641") }

    before do
      # TODO ?がURLの末尾に付くのは想定外なので、nicoqueryを修正する。
      WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm17675606?").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => Fixture.getthumbinfo_sm17675606, :headers => {})

      # sm17675606の説明文に記載されたマイリストのURL
      WebMock.stub_request(:get, "http://www.nicovideo.jp/mylist/31776968?numbers=1&rss=2.0").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => Fixture.mylist_31776968, :headers => {})

      WebMock.stub_request(:get, "http://www.nicovideo.jp/mylist/29776641?numbers=1&rss=2.0").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => Fixture.mylist_29776641, :headers => {})

      WebMock.stub_request(:get, "http://www.nicovideo.jp/mylist/30544641?numbers=1&rss=2.0").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => Fixture.mylist_30544641, :headers => {})

      WebMock.stub_request(:get, "http://www.nicovideo.jp/mylist/32098741?numbers=1&rss=2.0").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => Fixture.mylist_32098741, :headers => {})

      PartOneMovie.retrieve_series_mylist
    end

    subject { PartOneMovie.first }

    it "should retrieve series mylist" do
      expect(subject.series_mylist).to eq 31776968
    end
  end
end
