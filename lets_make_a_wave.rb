require 'wave_file'

wav = WaveFile.new

# square wave
400.times do
	10.times { wav.data << 0 }
	10.times { wav.data << 255 }
end

# sawtooth wave
(0...8000).each do |i|
	wav.data << (i*13) % 256
end

#triangle wave
(0...8000).each do |i|
	if i*13 % 256 < 128
		wav.data << i*26 % 256
	else
		wav.data << 255 - (i*26) % 256
	end
end

# sine wave
(0...8000).each do |i|
	wav.data << (127*(1 + Math.sin(i/Math::PI))).round
end

wav.save("i_is_a_musician.wav")