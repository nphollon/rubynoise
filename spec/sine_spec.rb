require 'spec_helper'
require 'sine'

describe SineWave do
	subject { SineWave.new(60) }

	it "inherits from Waveform" do
		subject.class.ancestors.should include(Waveform)
	end

	it "evaluates to a sinusoid" do
		(0...10).each do |i|
			subject.eval(i/10.0).should be_within(1e-3).of(0.5 + 0.5*Math.sin(i*0.2*Math::PI))
		end
	end

	it "can be exported" do
		subject.export_to_wav(5)
	end
end