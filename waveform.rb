require_relative '../waves/wave_file'

module Waveform
	class Waveform
		attr_reader :frequency

		def initialize(frequency)
			@frequency = frequency
		end

		def eval(phase)
			phase < 0.5 ? 0 : 1
		end

		def sample(phase)
			(eval(phase) * 0xff).to_i
		end

		def export_to_wav(duration)
			wav = WaveFile.new
			num_samples = (duration * wav.sample_rate).to_i
			samples_per_wavelength = wav.sample_rate / @frequency.to_f

			(0...num_samples).each do |i|
				wavelengths = i / samples_per_wavelength
				phase = wavelengths - wavelengths.floor
				wav.data << sample(phase)
			end

			wav
		end
	end


  class SineWave < Waveform
    def eval(phase)
      0.5 * ( 1 + Math.sin( phase * 2*Math::PI ) )
    end
  end

  class TriangleWave < Waveform
    def eval(phase)
      (phase < 0.5) ? 2*phase : 2*(1 - phase)
    end
  end

  class SquareWave < Waveform
    def eval(phase)
      (phase < 0.5) ? 0 : 1
    end
  end

  class SawtoothWave < Waveform
    def eval(phase)
      phase
    end
  end
end