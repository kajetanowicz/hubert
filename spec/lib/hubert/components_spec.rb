require 'spec_helper'

module Hubert
  describe Components do
    let(:components) { Components.new }

    describe '#protocol=' do
      it 'assigns the protocol' do
        components.protocol = 'HTTP'

        expect(components.protocol).to eq('http')
      end

      it 'raises an exception if the protocol is invalid' do
        expect { components.protocol = 'ftp' }.
          to raise_error(InvalidProtocol, /\[ftp\]/)
      end

      context 'when passed as a symbol' do
        it 'converts protocol to a String' do
          components.protocol = :http

          expect(components.protocol).to eq('http')
        end
      end
    end

    describe '#http!' do
      it 'assigns the HTTP protocol' do
        components.http!

        expect(components.protocol).to eq('http')
      end
    end

    describe '#https!' do
      it 'assigns the HTTPS protocol' do
        components.https!

        expect(components.protocol).to eq('https')
      end
    end

    describe '#host=' do
      it 'assigns the host' do
        components.host = 'example.com'

        expect(components.host).to eq('example.com')
      end

      it 'removes the path component from the host' do
        components.host = 'example.com/path/to/resource'

        expect(components.host).to eq('example.com')
      end

      it 'removes the protocol component from the host' do
        components.host = 'http://example.com/path/to/resource'

        expect(components.host).to eq('example.com')
      end
    end

    describe '#path_prefix' do
      it 'assigns the path prefix' do
        components.path_prefix = 'foo/bar/baz'

        expect(components.path_prefix).to eq('/foo/bar/baz')
      end

      it 'removes slashes from the end of the path' do
        components.path_prefix = '/foo/bar/baz/'

        expect(components.path_prefix).to eq('/foo/bar/baz')
      end
    end

    describe '#port' do
      it 'returns default HTTP port (80)' do
        expect(components.port).to eq('80')
      end

      context 'when using HTTPS' do
        it 'returns the default HTTPS port (443)' do
          components.https!

          expect(components.port).to eq('443')
        end
      end

      context 'when using HTTP' do
        it 'returns the default HTTP port (80)' do
          components.http!

          expect(components.port).to eq('80')
        end
      end
    end

    describe '#port=' do
      it 'assings port' do
        components.port = 123

        expect(components.port).to eq('123')
      end
    end
  end
end
