require 'spec_helper'

module Hubert
  describe Builder do
    describe '#host=' do

      let(:builder) do
        Builder.new do |builder|
          builder.host = 'http://example.com'
        end
      end

      it 'assigns the host' do
        expect(builder.host).to eq('example.com')
      end

    end
  end
end
