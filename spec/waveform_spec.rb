require 'spec_helper'
require 'waveform'

describe Waveform do
	subject { Waveform.new(60) }

	its(:frequency) { should == 60 }

	context "eval" do
		it "should evaluate to 0 if phase < 0.5" do
			subject.eval(0.2).should == 0
		end

		it "should evaluate to 1 if phase >= 0.5" do
			subject.eval(0.7).should == 1
		end
	end

	describe "export wave" do
		subject { Waveform.new(60).export_to_wav(1) }

		its(:duration) { should be_within(0.01).of(1)}
		its(:data) { should =~ /\x00\xFF/ }

		it "should have roughly 67 \\xFFs per cycle" do
			subject.data[/\xFF+/].length.should be_within(1).of(67)
		end

		it "should have roughly 67 \\x00s per cycle" do
			subject.data[/\x00+/].length.should be_within(1).of(67)
		end
	end
end