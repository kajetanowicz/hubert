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

      context 'when path contains placeholders' do
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

      context 'when hash contains additional keys' do
        subject do
          template.render(parent_id: 10, id: 512, sort: 'name', order: 'asc')
        end

        let(:path) do
          'a/path/:parent_id/:id/'
        end

        it 'builds a query string' do
          expect(subject).to eq('/a/path/10/512?sort=name&order=asc')
        end
      end

      context 'when unable to find a placeholder substitution' do
        subject do
          template.render(id: 123)
        end

        let(:path) do
          'a/path/:id/:name'
        end

        it 'raises an exception' do
          expect { subject }.to raise_error(KeyNotFound, /\[name\]/)
        end
      end

      context 'when query string contains characters that are not allowed' do
        subject do
          template.render(escape: 'all the things', like: 'a boss!!')
        end

        let(:path) do
          'a/path/without/placeholders'
        end

        it 'escapes all illegal characters' do
          expect(subject).to eq(
            '/a/path/without/placeholders?escape=all+the+things&like=a+boss%21%21'
          )
        end
      end

      context 'when segments contain illegal characters' do
        subject do
          template.render(what: 'all the things', who: 'a boss')
        end

        let(:path) do
          'escape/:what/like/:who'
        end

        it 'escapes all illegal characters' do
          expect(subject).to eq('/escape/all+the+things/like/a+boss')
        end
      end
    end
  end
end
