require 'spec_helper'
require 'nicoquery'
require 'fixtures/part_one_movies_from_20130901_to_20130905'


describe Crawler do
  describe ".get_latest_part1_movie_from_web" do
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

        Crawler.get_latest_part1_movie_from_web
      end

      it "should acquire part one movie from 2013/9/1 0:00:00 to 2013/9/5 23:59:59 and storage them to DB" do
        movies = PartOneMovie.order(:publish_date)
        # movies.first is 'latest_movie'
        expect(movies.second.publish_date).to be > latest_movie.publish_date
      end
    end
  end
  
  describe ".retrieve_series_mylist" do
    context "when target mylist contains some movie" do
      let!(:movie) { FactoryGirl.create(:part_one_movie,  video_id: 'sm1001',
                                                          publish_date: Time.local(2013, 9, 1, 0, 0, 0),
                                                          mylist_references: "1001 2001") }

      before do
        # TODO ?がURLの末尾に付くのは想定外なので、nicoqueryを修正する。
        WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm1001?").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.getthumbinfo_sm1001, :headers => {})

        WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm1002?").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.getthumbinfo_sm1002, :headers => {})

        WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm1003?").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.getthumbinfo_sm1003, :headers => {})

        WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm2001?").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.getthumbinfo_sm2001, :headers => {})

        WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm2002?").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.getthumbinfo_sm2002, :headers => {})

        WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm2003?").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.getthumbinfo_sm2003, :headers => {})

        # sm1001の説明文に記載されたマイリストのURL
        WebMock.stub_request(:get, "http://www.nicovideo.jp/mylist/1001?numbers=1&rss=2.0").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.mylist_1001, :headers => {})

        WebMock.stub_request(:get, "http://www.nicovideo.jp/mylist/2001?numbers=1&rss=2.0").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.mylist_2001, :headers => {})

        PartOneMovie.retrieve_series_mylist
      end

      subject { PartOneMovie.first }

      it "should retrieve series mylist" do
        expect(subject.series_mylist).to eq 1001
      end
    end

    context "when base movie is deleted" do
      let!(:movie) { FactoryGirl.create(:part_one_movie,  video_id: 'sm3001',
                                                          publish_date: Time.local(2013, 9, 1, 0, 0, 0)) }

      before do
        WebMock.stub_request(:get, "http://ext.nicovideo.jp/api/getthumbinfo/sm3001?").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => Fixture.getthumbinfo_deleted, :headers => {})
      end
    end
  end
end