require 'pry'
class Dictor
  def initialize(verbose: false, dict:, phones:)
    @dict = dict
    @phones = phones
    @verbose = verbose
    @number_map = {}
    @number_suggestions = {}
    @wordlist = []
    @encoder = {}
    %w{abc def ghi jkl mno pqrs tuv wxyz}.to_enum.with_index(2).each do |letters, index|
      letters.scan(/./).map{|l| @encoder[l] = index}
    end
  end

  def process!
    log('Loading the data from dictionary file')
    load_dictionary
    log('Start conversion to fancy phone numbers')
    convert_phone_numbers
    log('Printing the results')
    print_number_suggestions
  end

  def print_number_suggestions

  end

  def convert_phone_numbers
    @phones.each do |phone|
      formatted_phone = phone.to_i.to_s
      @number_suggestions[formatted_phone] ||= []
      @number_map.keys.each do |number|
        next unless formatted_phone.include? number
        number_parts = formatted_phone.partition(number).compact.reject(&''.method(:==))
        if number_parts.size == 1
          @number_suggestions[formatted_phone] = @number_map[formatted_phone]
          break
        end
        remaining_nums = number_parts - [number]
        new_mapper = {}
        remaining_nums.each do |num|
          @number_map.keys.each do |new_number|
            next unless num.include? new_number
            result = num.partition(new_number).compact.reject(&''.method(:==))
            if result.size == 1
              new_mapper[num] = @number_map[formatted_phone]
            end
          end
        end
        phone_copy = formatted_phone
        binding.pry
        phone_copy[number] = @number_map[number].last
        new_mapper.keys.each do |n|
          phone_copy[n] = new_mapper[n].last
        end
        @number_suggestions[formatted_phone] = phone_copy
      end
    end
    binding.pry
  end

  def recursive_search(formatted_phone, iteration)
    @number_map.keys.each do |number|
      return nil unless formatted_phone.include? number
      value_map = {}
      number_parts = formatted_phone.partition(number).compact.reject(&''.method(:==))
      value_map[number] = @number_map[number]
      if number_parts.size == 1 && iteration.zero?
        @wordlist.push(@number_map[number])
          next
        end
        remaining_parts = number_parts - [number]
      remaining_parts.each do |part|
        recursive_search(part)
      end
    end
  end

  def load_dictionary
    @dict.each do |word|
      formatted_word = word.downcase
      formatted_number = formatted_word.scan(/./).map{ |l| @encoder[l]}.join.to_s
      @number_map[formatted_number] ||= []
      @number_map[formatted_number].push(formatted_word)
    end
    @number_map
  end

  def log(statement)
    puts statement if @verbose
    statement
  end
end

