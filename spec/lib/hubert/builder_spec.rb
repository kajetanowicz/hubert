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

      it 'replaces placeholders with values' do
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

    describe '#url' do
      let(:builder) do
        Builder.new do |b|
          b.http!
          b.host = 'example.com'
          b.port = port
          b.path_prefix = 'api'
        end
      end

      let(:port) { 80 }

      it 'returns full URL' do
        expect(builder.url('/path/to/resource/:id', id: 11, sort: 'name'))
          .to eq('http://example.com/api/path/to/resource/11?sort=name')
      end

      context 'when using non-default port number' do
        let(:port) { 8080 }

        it 'creates an url with port number' do
          expect(builder.url('/path/to/resource/:id', id: 11, sort: 'name'))
            .to eq('http://example.com:8080/api/path/to/resource/11?sort=name')
        end
      end

      context 'when protocol is not set' do
        let(:builder) do
          Builder.new do |b|
            b.host = 'example.com'
          end
        end

        it 'uses default http protocol' do
          expect(builder.url('/path/to/resource'))
            .to eq('http://example.com/path/to/resource')
        end
      end

      context 'when domain is not set' do
        let(:builder) { Builder.new }

        it 'raises an exception' do
          expect { builder.url('/path') }.to raise_error(HostNotSet)
        end
      end
    end
  end
end
