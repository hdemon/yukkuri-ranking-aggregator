require 'spec_helper'

describe MylistLog do
  pending "add some examples to (or delete) #{__FILE__}"
  describe '.delta' do
    before do
    end

    subject { MylistLog.delta(Time.utc(2000, 1, 1), Time.utc(2000, 1, 2)) }

    it "should return difference between two time given as args" do
      expect(subject[:view]).to eq(100)
    end
  end
end
