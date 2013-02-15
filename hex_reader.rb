class HexReader
	private_class_method :new

	class << self
		def convert_to_binary(infile, outfile=nil)
			bin_string = translate( IO.read(infile) || "" ).pack "C*"
			IO.binwrite(outfile, bin_string) if outfile
			bin_string
		end

		def translate(text)
			clean_text = remove_whitespace(text)
			raise RuntimeError if invalid?(clean_text)

			byte_array = []
			high_nibble = true

			clean_text.each_char do |c|
				if high_nibble
					byte_array << c.to_i(0x10) * 0x10
				else
					byte_array[-1] += c.to_i(0x10)
				end
				high_nibble = !high_nibble
			end

			byte_array
		end

		def remove_whitespace(text)
			clean_text = text.clone
			clean_text[/\s/] = '' while clean_text =~ /\s/
			clean_text
		end

		def invalid?(hex_text)
			hex_text =~ /[^a-fA-F0-9]/ or hex_text.length % 2 == 1
		end
	end
end