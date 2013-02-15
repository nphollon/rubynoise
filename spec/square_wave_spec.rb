require 'spec_helper'
require_relative '../wave_file'
require_relative '../square_wave'

describe SquareWave do
	subject { SquareWave.new(amplitude = 1, frequency = 60) }
	its(:frequency) {should == 60}
	its(:amplitude) {should == 1}

	describe "wave output" do
		subject { SquareWave.new(1,60).export_to_wav(5) }

		its(:class) {should == WaveFile}
	end
end