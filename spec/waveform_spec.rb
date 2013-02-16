require 'spec_helper'
require_relative '../waveform'

describe Waveform do
	it { should respond_to(:export_to_wav) }
	it { should respond_to(:eval) }
end