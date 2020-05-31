#!/usr/bin/env ruby
require 'pry'
require 'set'
class Dictor
  def initialize(verbose: false, dict:, phones:)
    @dict = dict
    @phones = phones
    @verbose = verbose
    @number_map = {}
    @number_suggestions = {}
    @encoder = {}
    %w{abc def ghi jkl mno pqrs tuv wxyz}.to_enum.with_index(2).each do |letters, index|
      letters.scan(/./).map{|l| @encoder[l] = index}
    end

  end

  def process!
    log('Loading the data from dictionary file')
    load_dictionary
    log('reading phone numbers')
    read_phone_numbers
    log('Printing the results')
    print_number_suggestions
  end

  def print_number_suggestions
    @number_suggestions.each do |number, values|
      puts "The number suggestions for #{number} are:"
      values.to_a.each_with_index do |value,i|
        puts "#{i+1}: #{value.chomp.upcase}"
      end
    end
  end

  def read_phone_numbers
    @phones.each do |phone|
      phone.gsub!(/[^\d]/, '')
      next if phone.empty?
      @wordlist = Set.new
      create_wordspace(phone)
      @number_suggestions[phone] = @wordlist
    end
    @number_suggestions
  end

  def build_fancy_number_list(wordspace, phone,  word = '')
    pointer = word.length - word.count('-')
    if pointer >= phone.size
      word.chop! if word.end_with? '-'
      word.reverse!.chop!.reverse! if word[0] == '-'
      @wordlist << word
      return
    end
    wordspace[pointer].each do  |number_map_values|
      next unless number_map_values
      number_map_values.each do |value|
        new_word = value.empty? ? "#{value}" : "#{word}-#{value}"
        full_word_matches(wordspace, phone, new_word)
        new_word = "#{new_word}-#{phone[pointer + value.length]}"
        partial_word_matches(wordspace, phone, new_word)
      end
    end
    @wordlist
  end

  def create_wordspace(phone)
    wordspace = Array.new(phone.size)
    (0..phone.size).each do |i|
      length_list = wordspace[i] = Array.new(phone.size - i)
      num_word = ''
      (i...phone.size).each do |j|
        num_word << phone[j]
        length_list[j - i] = @number_map[num_word]
      end
    end
    build_fancy_number_list(wordspace, phone)
  end

  def full_word_matches(wordspace, phone, new_word)
    build_fancy_number_list(wordspace, phone, new_word)
  end

  def partial_word_matches(wordspace, phone, new_word)
    build_fancy_number_list(wordspace, phone, new_word)
  end

  def load_dictionary
    @dict.each do |word|
      next if (word =~ /\A[-+]?[0-9]+\z/)&.zero?
      formatted_word = word.downcase
      formatted_number = formatted_word.scan(/./).map{ |l| @encoder[l]}.join.to_s
      @number_map[formatted_number] ||= []
      @number_map[formatted_number].push(formatted_word.chomp)
    end
    @number_map
  end

  def log(statement)
    puts statement if @verbose
    statement
  end
end

