require 'spec_helper'
require 'sawtooth'

describe SawtoothWave do
	subject { SawtoothWave.new(60) }

	it "inherits from Waveform" do
		subject.class.ancestors.should include(Waveform)
	end

	it "evaluates to a line" do
		(0...10).each do |i|
			subject.eval(i/10.0).should be_within(1e-3).of(i/10.0)
		end
	end
end