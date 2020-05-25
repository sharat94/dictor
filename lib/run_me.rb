require 'optparse'
require_relative 'dictor'

@options= {}
OptionParser.new do |opts|
    opts.on("-v", "--verbose", "Show logs") do
      @options[:verbose] = true
    end
    opts.on('--dictionary DICTFILE', '-d', 'Specify dictionary file') { |file|
      File.open(file) { |f| @options[:dict] = f.readlines }
    }
    opts.on('--phonenumbers PHONEFILE', '-p', 'Specify phone numbers file') { |file|
      File.open(file) { |f| @options[:phones] = f.readlines }
      }
end.parse!
phones = @options[:phones] || File.open('phone.txt') { |f| @options[:phones] = f.readlines }
dict = @options[:dict] || File.open('dict.txt') { |f| @options[:dict] = f.readlines }
Dictor.new(verbose: @options[:verbose],
           dict: dict,
           phones: phones).process!

