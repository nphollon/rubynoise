class WaveFile
	DATA_SUBCHUNK_ID = 'data'
	AUDIO_FORMAT = 1
	FMT_SUBCHUNK_SIZE = 16
	FMT_SUBCHUNK_ID = 'fmt '
	FORMAT = 'WAVE'
	CHUNK_ID = 'RIFF'

	attr_reader :num_channels, :sample_rate, :bits_per_sample, :num_samples

	attr_accessor :data

	def initialize(num_channels = 1, sample_rate = 8000, bits_per_sample = 8)
		@num_channels = num_channels
		@sample_rate = sample_rate
		@bits_per_sample = bits_per_sample
		@data = ""
	end

	def duration
		num_samples / sample_rate.to_f
	end

	def self.load(filename)
		parse IO.binread(filename)
	end

	def self.parse(wave_content)
		num_channels = wave_content[22...24].unpack("v")[0]
		sample_rate = wave_content[24...28].unpack("V")[0]
		bits_per_sample = wave_content[34...36].unpack("v")[0]
		wave_file = WaveFile.new(num_channels, sample_rate, bits_per_sample)
		wave_file.data = wave_content[44..-1]
		wave_file
	end

	def save(filename)
		IO.binwrite(filename, binary_string)
	end

	def binary_string
		riff_header + fmt_subchunk + data_subchunk
	end

	def riff_header
		chunk_id + [chunk_size].pack("V") + format
	end

	def fmt_subchunk
		fmt_subchunk_id + [fmt_subchunk_size].pack("V") + [audio_format].pack("v") +
			[num_channels].pack("v") + [sample_rate].pack("V") + [byte_rate].pack("V") +
			[block_align].pack("v") + [bits_per_sample].pack("v")
	end

	def data_subchunk
		data_subchunk_id + [data_subchunk_size].pack("V") + data
	end


	def chunk_id
		CHUNK_ID
	end

	def chunk_size
		36 + data_subchunk_size
	end

	def format
		FORMAT
	end

	def fmt_subchunk_id
		FMT_SUBCHUNK_ID
	end

	def fmt_subchunk_size
		FMT_SUBCHUNK_SIZE
	end

	def audio_format
		AUDIO_FORMAT
	end

	def byte_rate
		block_align * sample_rate
	end

	def block_align
		bits_per_sample/8 * num_channels
	end

	def data_subchunk_id
		DATA_SUBCHUNK_ID
	end

	def data_subchunk_size
		num_samples * block_align
	end

	def num_samples
		data.length
	end

	def ==(object)
		self.class == object.class
	end
end