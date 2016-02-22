Gem::Specification.new do |s|
  s.name        = 'mkmf-cu'
  s.version     = '0.1.0'
  s.date        = '2016-02-21'
  s.summary     = "mkmf wrapper for CUDA"
  s.description = "mkmf wrapper for CUDA"
  s.authors     = ["Takashi Tamura"]
  s.email       = ''
  s.files       = ["lib/mkmf-cu.rb", "lib/mkmf-cu/opt.rb"]
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'
  s.executables << "mkmf-cu-nvcc"
end