require 'waveform'

class TriangleWave < Waveform
	def eval(phase)
		(phase < 0.5) ? 2*phase : 2*(1 - phase)
	end
end