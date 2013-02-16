require 'spec_helper'
require_relative '../wave_file'
require_relative '../square_wave'

describe SquareWave do
	subject { SquareWave.new(amplitude = 1, frequency = 60) }
	its(:frequency) { should == 60 }
	its(:amplitude) { should == 1 }

	describe "wave output" do
		subject { SquareWave.new(1,60).export_to_wav(5) }

		its(:class) { should == WaveFile }
		its(:duration) { should be_within(0.01).of(5) }

		its(:data) { should =~ /\x00\xFF/ }
		
		it "should have roughly 67 \\xFFs per cycle" do
			subject.data[/\xFF+/].length.should be_within(1).of(67)
		end

		it "should have roughly 67 \\x00s per cycle" do
			subject.data[/\x00+/].length.should be_within(1).of(67)
		end
	end
end