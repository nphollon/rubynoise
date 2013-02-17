require 'spec_helper'
require 'wave_file'

describe WaveFile do
	its(:num_channels) {should == 1}
	its(:sample_rate) {should == 8000}
	its(:bits_per_sample) {should == 8}
	its(:data) {should == ""}

	its(:block_align) {should == 1}
	its(:byte_rate) {should == 8000}
	its(:num_samples) {should == 0}
	its(:data_subchunk_size) {should == 0}
	its(:chunk_size) {should == 36}
	its(:duration) {should == 0}

	its(:data_subchunk_id) {should == 'data'}
	its(:audio_format) {should == 1}
	its(:fmt_subchunk_size) {should == 16}
	its(:fmt_subchunk_id) {should == 'fmt '}
	its(:format) {should == 'WAVE'}
	its(:chunk_id) {should == 'RIFF'}

	its(:riff_header) {should == "RIFF\x24\x00\x00\x00WAVE"}
	its(:fmt_subchunk) do 
		should == "fmt \x10\x00\x00\x00"+"\x01\x00"+"\x01\x00"+
			"\x40\x1F\x00\x00"+"\x40\x1F\x00\x00"+"\x01\x00"+"\x08\x00"
	end
	its(:data_subchunk) {should == "data\x00\x00\x00\x00"}

	it { should_not == Object.new }
	it { should == WaveFile.new(options = {a_key: 5}) }

	context "with creation options and data" do
		subject { WaveFile.new(2, 14400, 16) }
		before { subject.data = "hi there" }

		its(:num_channels) {should == 2}
		its(:bits_per_sample) {should == 16}
		its(:sample_rate) {should == 14400}

		its(:block_align) {should == 4}
		its(:byte_rate) {should == 57600}

		its(:num_samples) {should == 8}
		its(:data_subchunk_size) {should == 32}
		its(:chunk_size) {should == 68}
		its(:duration) {should == 8/14400.to_f}

		its(:riff_header) {should == "RIFF\x44\x00\x00\x00WAVE"}
		its(:fmt_subchunk) do 
			should == "fmt \x10\x00\x00\x00"+"\x01\x00"+"\x02\x00"+
				"\x40\x38\x00\x00"+"\x00\xE1\x00\x00"+"\x04\x00"+"\x10\x00"
		end
		its(:data_subchunk) {should == "data\x20\x00\x00\x00hi there"}
	end

	it "provides file data as a string" do
		subject.binary_string.should == subject.riff_header + subject.fmt_subchunk +
			subject.data_subchunk
	end
	
	it "can save to a file" do
		outfile = "out.wav"
		IO.should_receive(:binwrite).with(outfile, subject.binary_string)
		subject.save(outfile)
	end

	context "parsing wave files" do
		let (:sample_wav_data) do
			"RIFF8\x00\x00\x00WAVEfmt \x10\x00\x00\x00\x01\x00\x01\x00@\x1F\x00" +
			"\x00@\x1F\x00\x00\x01\x00\b\x00data\x14\x00\x00\x00\x00\x00\xFF" +
			"\xFF\x00\x00\xFF\xFF\x00\x00\xFF\xFF\x00\x00\xFF\xFF\x00\x00\xFF\xFF"
		end

		subject { WaveFile.parse(sample_wav_data) }

		its(:data) {should == sample_wav_data[44..-1] }
		its(:num_channels) {should == 1}
		its(:sample_rate) {should == 8000}
		its(:bits_per_sample) {should == 8}
		its(:binary_string) {should == sample_wav_data}

		it "can load a file" do
			IO.stub(:binread).and_return(sample_wav_data)
			subject.should == WaveFile.load("filename.wav")
		end
	end
end