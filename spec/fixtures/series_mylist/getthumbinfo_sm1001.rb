module Fixture
  def self.getthumbinfo_sm1001
    <<-EOS
      <nicovideo_thumb_response status="ok">
        <thumb>
        <video_id>sm1001</video_id>
        <title>動画 第1話</title>
        <description>
        mylist/1001 mylist/2001
        </description>
        <thumbnail_url>http://tn-skr3.smilevideo.jp/smile?i=1001</thumbnail_url>
        <first_retrieve>2012-04-29T10:36:47+09:00</first_retrieve>
        <length>19:41</length>
        <movie_type>mp4</movie_type>
        <size_high>95312847</size_high>
        <size_low>58686061</size_low>
        <view_counter>474969</view_counter>
        <comment_num>11271</comment_num>
        <mylist_counter>11864</mylist_counter>
        <last_res_body></last_res_body>
        <watch_url>http://www.nicovideo.jp/watch/sm1001</watch_url>
        <thumb_type>video</thumb_type>
        <embeddable>1</embeddable>
        <no_live_play>0</no_live_play>
        <tags domain="jp">
        <tag lock="1">ゲーム</tag>
        <tag lock="1">ゆっくり実況プレイ</tag>
        <tag>ゆっくり実況プレイpart1リンク</tag>
        </tags>
        <user_id>1</user_id>
        </thumb>
      </nicovideo_thumb_response>
    EOS
  end
end
