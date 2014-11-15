require 'spec_helper'

module Hubert
  describe Builder do
    let(:builder) do
      Builder.new
    end

    describe '#protocol=' do
      it 'assigns the protocol' do
        builder.protocol = 'HTTP'

        expect(builder.protocol).to eq('http')
      end

      it 'raises an exception if the protocol is invalid' do
        expect { builder.protocol = 'ftp' }.
          to raise_error(InvalidProtocol, /\[ftp\]/)
      end
    end

    describe '#http!' do
      it 'assigns the HTTP protocol' do
        builder.http!

        expect(builder.protocol).to eq('http')
      end
    end

    describe '#https!' do
      it 'assigns the HTTPS protocol' do
        builder.https!

        expect(builder.protocol).to eq('https')
      end
    end

    describe '#host=' do
      it 'assigns the host' do
        builder.host = 'http://example.com/'

        expect(builder.host).to eq('example.com')
      end

      it 'removes a path from the host' do
        builder.host = 'http://example.com/path/to/resource'

        expect(builder.host).to eq('example.com')
      end
    end
  end
end
