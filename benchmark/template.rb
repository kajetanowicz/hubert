require 'benchmark'
require 'hubert'

probes = 100000
Benchmark.bm(25) do |b|
  b.report('Hubert::Template#render') do

    template = Hubert::Template.new('/simple/path/:id/some/:name')
    context = { id: 123, name: 'hello world', sort: 'name', order: 'asc' }

    probes.times { template.render(context) }
  end
end
