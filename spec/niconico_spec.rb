require 'spec_helper'
require 'nicoquery'
require 'fixtures/getthumbinfo_sm17675606'
require 'fixtures/mylist_31776968'
require 'fixtures/mylist_29776641'
require 'fixtures/mylist_30544641'
require 'fixtures/mylist_32098741'
require 'niconico'
require 'mylist'


describe NicoNico do
  describe ".getSeriesMylist" do
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

      NicoNico.retrieve_series_mylist_from_part_one
    end

    subject { Mylist.first }

    it "should retrieve series mylist" do
      expect(subject.mylist_id).to eq 31776968
    end
  end
end
