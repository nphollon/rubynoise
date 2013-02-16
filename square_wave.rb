class SquareWave
	attr_reader :frequency, :amplitude

	def initialize(amplitude, frequency)
		@amplitude = amplitude
		@frequency = frequency
	end

	def export_to_wav(duration)
		wav = WaveFile.new
		num_samples = (duration * wav.sample_rate).to_i
		samples_per_wavelength = wav.sample_rate / @frequency.to_f

		(0...num_samples).each do |i|
			wavelengths = i / samples_per_wavelength
			phase = wavelengths - wavelengths.floor
			if phase < 0.5
				wav.data << 0
			else
				wav.data << 0xff
			end
		end

		wav
	end
end