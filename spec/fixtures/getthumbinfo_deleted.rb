module Fixture
  def self.getthumbinfo_deleted
    <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<nicovideo_thumb_response status="fail">
  <error>
    <code>DELETED</code>
    <description>deleted</description>
  </error>
</nicovideo_thumb_response>
    EOS
  end
end
