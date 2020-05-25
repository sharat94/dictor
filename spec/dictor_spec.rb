require 'dictor'

require 'pry'
describe Dictor do
  before do
    @dict = %w{call me}
    @phones = %w{2255634}
    @dictor = Dictor.new(verbose: true,
                         dict: @dict,
                         phones: @phones)
  end
  describe '#load dictionary' do
    context 'checks if the words were loaded corrected from dictionary file' do
      it 'returns the number map for the words in the dictionary' do
        expected_result = {"2255" => ["call"], "63" => ["me"]}
        actual_result = @dictor.load_dictionary
        expect(actual_result).to eq(expected_result)
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



