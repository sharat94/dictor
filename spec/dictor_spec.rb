require 'dictor'

require 'pry'
describe Dictor do
  before do
    @dict = %w{call me}
    @dict1 = %w{1 2 729}
    @phones = %w{2255634}
    @phones1 = %w{22556jksjaopw34}
    @dictor = Dictor.new(verbose: true,
                         dict: @dict,
                         phones: @phones)
    @dictor1 = Dictor.new(verbose: true,
                         dict: @dict1,
                         phones: @phones)
    @dictor2 = Dictor.new(verbose: true,
                          dict: @dict,
                          phones: @phones1)
  end
  describe '#load dictionary' do
    context 'checks if the words were loaded corrected from dictionary file' do
      it 'returns the number map for the words in the dictionary' do
        expected_result = {"2255" => ["call"], "63" => ["me"]}
        actual_result = @dictor.load_dictionary
        expect(actual_result).to eq(expected_result)
      end
    end
    context 'when numbers are loaded into dictionary file' do
      it 'returns the number map for the words in the dictionary' do
        expected_result = {}
        actual_result = @dictor1.load_dictionary
        expect(actual_result).to eq(expected_result)
      end
    end
  end
  describe '#read_phone_numbers' do
    context 'processes individual phone number to find different suggestions' do
      it 'loads number suggestions with valid phone words' do
        expected_result = ["call-me-4"]
        @dictor.load_dictionary
        result = @dictor.read_phone_numbers
        expect(result.values.map!(&:to_a).flatten).to eq(expected_result)
      end
    end
    context 'ignores alphabets added in phonenumbers and process them ignoring the alphabets' do
      it 'loads number suggestions with valid phone words' do
        expected_result = ["call-me-4"]
        @dictor2.load_dictionary
        result = @dictor2.read_phone_numbers
        expect(result.values&.map!(&:to_a)&.flatten).to eq(expected_result)
      end
    end
  end

  describe '#log' do
    context 'logs the steps if option is in verbose' do
      it 'returns statement' do
        expect(@dictor.log('Mic Testing')).to eq('Mic Testing')
      end
    end
  end
end



