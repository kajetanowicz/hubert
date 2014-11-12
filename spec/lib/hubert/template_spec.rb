require 'spec_helper'

module Hubert
  describe Template do
    let(:template) do
      Template.new(path)
    end

    let(:path) do
      '/first/second/third/'
    end

    describe '#render' do
      subject { template.render({}) }

      it 'returns a string' do
        expect(subject).to be_kind_of(String)
      end

      it 'renders a path' do
        expect(subject).to include('first/second/third')
      end

      it 'returns a path prefixed with "/"' do
        expect(subject).to match(/^\/[^\/]/)
      end

      it 'removes fillowing slash from the path' do
        expect(subject[-1]).not_to eq('/')
      end

      context 'when path contains placehlders' do
        subject do
          template.render(name: 'test', id: 1234)
        end

        let(:path) do
          'a/path/to/:name/followed/by/:id/and/:name/again'
        end

        it 'substitues all placeholders with provided values' do
          expect(subject).to eq(
            '/a/path/to/test/followed/by/1234/and/test/again'
          )
        end
      end
    end
  end
end
