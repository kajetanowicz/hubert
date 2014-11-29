require 'spec_helper'

module Hubert
  describe DSL do
    let(:example_class) do
      Class.new { extend DSL }
    end

    it 'adds "path" method' do
      expect(example_class).to respond_to(:path)
    end

    describe '.path' do
      before do
        example_class.class_eval do
          path 'some/:simple/path/:id', as: :get_items
        end
      end

      it 'defines *_path method on any instance of the class' do
        expect(example_class.new).to respond_to(:get_items_path)
      end

      context 'when :as key is not present' do
        it 'raises an exception' do
          expect {
            example_class.class_eval do
              path 'some/:simple/path/:id'
            end
          }.to raise_error(PathAliasNotSet, /:as/)
        end
      end
    end
  end
end
