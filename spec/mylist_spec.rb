require 'spec_helper'
require 'nicoquery'
require 'fixtures/mylist_31776968'
require 'fixtures/video_array_for_mylist_31776968'
require 'mylist'


describe Mylist do
  describe "#mutable_info" do
    before do
      @mylist = FactoryGirl.create(:mylist, mylist_id: 31776968)
      @movies = []
      # mylist/31776968には以下の動画が含まれている。
      %w|sm19528141 sm19158627 sm18941512 sm18769635 sm18584857 sm18403727 sm18168678 sm18045928 sm17984294 sm17861062 sm17737886 sm17716335 sm17675606|.each do |video_id|
        movie = FactoryGirl.create(:movie, video_id: video_id)
        @mylist.movies << movie
      end

      WebMock.stub_request(:get, "http://www.nicovideo.jp/mylist/31776968?numbers=1&rss=2.0")
        .with(:headers => {
          'Accept' => '*/*; q=0.5, application/xml',
          'Accept-Encoding' => 'gzip, deflate',
          'User-Agent' => 'Ruby' })
        .to_return(:status => 200, :body => Fixture.mylist_31776968, :headers => {})

      WebMock.stub_request(:get, "http://i.nicovideo.jp/v3/video.array?v=sm19528141,sm19158627,sm18941512,sm18769635,sm18584857,sm18403727,sm18168678,sm18045928,sm17984294,sm17861062,sm17737886,sm17716335,sm17675606").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => Fixture.video_array_for_mylist_31776968, :headers => {})

      Mylist.get_mutable_movie_info_of_all_mylists
    end

    subject { MovieLogs.all }

    it "should acquire movie's info that belongs to the mylists saved in DB" do
      expect(subject[0].movie.video_id).to eql "sm19528141"
      expect(subject[1].movie.video_id).to eql "sm19158627"
      expect(subject[2].movie.video_id).to eql "sm18941512"
      expect(subject[3].movie.video_id).to eql "sm18769635"
      expect(subject[4].movie.video_id).to eql "sm18584857"
      expect(subject[5].movie.video_id).to eql "sm18403727"
      expect(subject[6].movie.video_id).to eql "sm18168678"
      expect(subject[7].movie.video_id).to eql "sm18045928"
      expect(subject[8].movie.video_id).to eql "sm17984294"
      expect(subject[9].movie.video_id).to eql "sm17861062"
      expect(subject[10].movie.video_id).to eql "sm17737886"
      expect(subject[11].movie.video_id).to eql "sm17716335"
      expect(subject[12].movie.video_id).to eql "sm17675606"
    end
  end
end
