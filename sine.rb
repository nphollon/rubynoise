require 'waveform'

class SineWave < Waveform
  def eval(phase)
    0.5 * ( 1 + Math.sin( phase * 2*Math::PI ) )
  end
end