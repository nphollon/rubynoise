class SquareWave
	attr_reader :frequency, :amplitude

	def initialize(amplitude, frequency)
		@amplitude = amplitude
		@frequency = frequency
	end

	def export_to_wav(duration)
		WaveFile.new
	end
end