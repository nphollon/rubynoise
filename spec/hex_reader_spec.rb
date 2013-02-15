require 'spec_helper'
require_relative '../hex_reader'

describe HexReader do
	it "cannot be initialized" do
		expect {HexReader.new}.to raise_error
	end

	it "should translate an empty string to an empty array" do
		HexReader.translate("").should == []
	end

	it "should translate 2 hex digits to an array of one number" do
		HexReader.translate("10").should == [0x10]
	end

	it "should translate 4 digits to an array of two 2-digit numbers" do
		HexReader.translate("1010").should == [0x10, 0x10]
	end

	it "should raise exception if number of digits is even" do
		expect {HexReader.translate("101")}.to raise_error(RuntimeError)
	end

	it "should ignore whitespace" do
		HexReader.translate("10 102 05\t7\n").should == [0x10, 0x10, 0x20, 0x57]
	end

	it "should not alter parameter during translation" do
		a = "1 2 3 4 5 6"
		HexReader.translate(a)
		a.should == "1 2 3 4 5 6"
	end

	it "should translate characters a-f & A-F as hex digits" do
		HexReader.translate("a b c D E f").should == [0xab, 0xcd, 0xef]
	end

	it "should raise exception if any other characters are translated" do
		expect {HexReader.translate("how dare i")}.to raise_error(RuntimeError)
	end

	it "reads text files" do
		filename = "testfile"
		IO.should_receive(:read).with(filename)
		HexReader.convert_to_binary(filename)
	end

	it "calls translate when reading a text file" do
		IO.stub(:read)
		HexReader.should_receive(:translate).with("").and_return
		HexReader.convert_to_binary("testfile")
	end

	it "sends contents of file to translate" do
		contents = "1 2 3 4 5 6"
		IO.stub(:read).and_return(contents)
		HexReader.should_receive(:translate).with(contents).and_return
		HexReader.convert_to_binary("testfile")
	end

	it "converts text files to binary strings" do
		IO.stub(:read)
		HexReader.stub(:translate).and_return([65, 66, 67])
		HexReader.convert_to_binary("testfile").should == "ABC"
	end

	it "optionally outputs binary string to a file" do
		outfile = "outfile"
		IO.stub(:read)
		HexReader.stub(:translate).and_return([65, 66, 67])
		IO.should_receive(:binwrite).with(outfile, "ABC")
		HexReader.convert_to_binary("testfile", outfile)
	end
end