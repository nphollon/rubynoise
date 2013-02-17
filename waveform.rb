require 'wave_file'

class Waveform
	attr_reader :frequency

	def initialize(frequency)
		@frequency = frequency
	end

	def eval(phase)
		phase < 0.5 ? 0 : 1
	end

	def export_to_wav(duration)
		wav = WaveFile.new
		num_samples = (duration * wav.sample_rate).to_i
		samples_per_wavelength = wav.sample_rate / @frequency.to_f

		(0...num_samples).each do |i|
			wavelengths = i / samples_per_wavelength
			phase = wavelengths - wavelengths.floor
			wav.data << eval(phase) * 0xff
		end

		wav
	end
end