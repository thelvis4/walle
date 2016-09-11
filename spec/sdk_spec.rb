require 'spec_helper'

describe Walle do
  describe Walle::SDK do

    describe "#parse_available_platforms" do
      it "return an array of plaform" do
        input = "android-24 \n android-22"
        sdk = Walle::SDK.new
        platforms = sdk.parse_available_platforms(input)
        expect(platforms).to eql ['android-24', 'android-22']
      end
    end

  end
end