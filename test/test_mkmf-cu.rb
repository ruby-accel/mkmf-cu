require "test/unit"
require "mkmf-cu/opt"

class TestMkmfCuOpt < Test::Unit::TestCase
  def test_opt

    opt_h = Hash.new{|h, k| h[k] = [] }
    argv = ["--mkmf-cu-ext=cxx", "-I.", "-I/opt/local/include/ruby-2.3.0/x86_64-darwin13", "-I/opt/local/include/ruby-2.3.0/ruby/backward", "-I/opt/local/include/ruby-2.3.0", "-I../../../../ext/culib", "-I/opt/local/include", "-I/opt/local/include", "-D_XOPEN_SOURCE", "-D_DARWIN_C_SOURCE", "-D_DARWIN_UNLIMITED_SELECT", "-D_REENTRANT", "-fno-common", "-pipe", "-Os", "-stdlib=libc++", "-x", "cu", "-O2", "-Wall", "-I/Developer/NVIDIA/CUDA-7.5/samples/common/inc/", "-arch", "x86_64", "-o", "culib.o", "-c", "../../../../ext/culib/culib.cxx"]
    assert_equal(["-arch", "-shared", "-rdynamic", "-dynamic", "-bundle", "-stdlib", "-pipe"].sort,
                 parse_ill_short(argv, opt_h).sort)

    h = Hash.new{|h, k| h[k] = [] }.merge({"-shared"=>[""], "-pipe"=>[""]})
    assert_equal(" --compiler-options -pipe",
                 compiler_option(h))

    opt_h = Hash.new{|h, k| h[k] = [] }
    argv = ["--mkmf-cu-ext=cxx", "-dynamic", "-bundle", "-o", "culib.bundle", "culib.o", "-L.", "-L/opt/local/lib", "-L/opt/local/lib", "-L.", "-L/opt/local/lib", "-Wl,-headerpad_max_install_names", "-fstack-protector", "-L/opt/local/lib", "-Wl,-undefined,dynamic_lookup", "-Wl,-multiply_defined,suppress", "-L/opt/local/lib", "-arch", "x86_64", "-lruby.2.3.0", "-lc++", "-lpthread", "-ldl", "-lobjc"]
    parse_ill_short_with_arg(argv, opt_h)
    assert_equal(["-headerpad_max_install_names",
                  "-undefined,dynamic_lookup",
                  "-multiply_defined,suppress"].sort,
                 opt_h["-Wl"].sort)

    h = Hash.new{|h, k| h[k] = [] }.merge({"-Wl"=>["-a", "-b"]})
    assert_equal(" --linker-options -a --linker-options -b",
                 linker_option(h))

  end
end
