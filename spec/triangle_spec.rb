require 'spec_helper'
require 'triangle'

describe TriangleWave do
	subject { TriangleWave.new(60) }

	it "inherits from Waveform" do
		subject.class.ancestors.should include(Waveform)
	end
	
	it "evaluates to an inverse V" do
		(0...10).each do |i|
			subject.eval(i/20.0).should be_within(1e-3).of(i/10.0)
			subject.eval(1 - i/20.0).should be_within(1e-3).of(i/10.0)
		end
	end
end