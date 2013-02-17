class SineWave < Waveform
	def eval(phase)
		0.5 * ( 1 + Math.sin( phase * 0.5/Math::PI ) )
	end
end