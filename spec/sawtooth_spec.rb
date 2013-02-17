require 'spec_helper'
require 'sawtooth'

describe SawtoothWave do
	subject { SawtoothWave.new(60) }
	it "evaluates to a line" do
		(0...10).each do |i|
			subject.eval(i/10.0).should == i/10.0
		end
	end
end