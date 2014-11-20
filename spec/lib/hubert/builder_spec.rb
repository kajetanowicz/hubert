require 'spec_helper'

module Hubert
  describe Builder do
    let(:builder) do
      Builder.new
    end

    describe '#path' do
      it 'renders a path' do
        expect(builder.path('/foo/bar')).to eq('/foo/bar')
      end

      it 'replaces placehlders with values' do
        expect(
          builder.path('create/:id/some/:name', id: 11, name: 'example')
        ).to eq('/create/11/some/example')
      end

      it 'caches templates' do
        expect(Template).to receive(:new).with('/path/to/resource/:id').once.and_call_original

        builder.path('/path/to/resource/:id', id: 11)
        builder.path('/path/to/resource/:id', id: 12)
      end
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

      context 'when passed as a symbol' do
        it 'converts protocol to a String' do
          builder.protocol = :http

          expect(builder.protocol).to eq('http')
        end
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
        builder.host = 'example.com'

        expect(builder.host).to eq('example.com')
      end

      it 'removes the path component from the host' do
        builder.host = 'example.com/path/to/resource'

        expect(builder.host).to eq('example.com')
      end

      it 'removes the protocol component from the host' do
        builder.host = 'http://example.com/path/to/resource'

        expect(builder.host).to eq('example.com')
      end
    end

    describe '#path_prefix' do
      it 'assigns the path prefix' do
        builder.path_prefix = 'foo/bar/baz'

        expect(builder.path_prefix).to eq('foo/bar/baz')
      end

      it 'removes slashes from the begining and the end of the path' do
        builder.path_prefix = '/foo/bar/baz/'

        expect(builder.path_prefix).to eq('foo/bar/baz')
      end
    end

    describe '#port' do
      it 'returns default HTTP port (80)' do
        expect(builder.port).to eq('80')
      end

      context 'when using HTTPS' do
        it 'returns the default HTTPS port (443)' do
          builder.https!

          expect(builder.port).to eq('443')
        end
      end

      context 'when using HTTP' do
        it 'returns the default HTTP port (80)' do
          builder.http!

          expect(builder.port).to eq('80')
        end
      end
    end

    describe '#port=' do
      it 'assings port' do
        builder.port = 123

        expect(builder.port).to eq('123')
      end
    end
  end
end
