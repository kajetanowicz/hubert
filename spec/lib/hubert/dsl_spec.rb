require 'spec_helper'

module Hubert
  describe DSL do
    let(:example_class) do
      Class.new { extend DSL }
    end

    %w( path url http! https! port host path_prefix ).each do |method|
      it "adds '#{method}' method to the host class" do
        expect(example_class).to respond_to(method)
      end
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

      context 'when calling new method' do
        subject do
          instance.get_items_path(simple: 'foo', id: 1234, sort: 'name', order: 'desc')
        end

        let(:instance) do
          example_class.new
        end

        it 'builds path using passed Hash' do
          expect(subject).to eq('/some/foo/path/1234?sort=name&order=desc')
        end
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
