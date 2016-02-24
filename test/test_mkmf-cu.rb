require "test/unit"
require "mkmf-cu/opt"

class TestMkmfCuOpt < Test::Unit::TestCase
  def test_opt

    opt_h = Hash.new{|h, k| h[k] = [] }
#    argv = ["--mkmf-cu-ext=cxx", "-I.", "-I/opt/local/include", "-D_XOPEN_SOURCE", "-D_DARWIN_C_SOURCE", "-fno-common", "-pipe", "-Os", "-stdlib=libc++", "-x", "cu", "-O2", "-Wall", "-arch", "x86_64", "-o", "culib.o", "-c", "culib.cxx"]

    argv = ["-fno-common", "-pipe", "-Os", "-stdlib=libc++", "-x", "cu", "-O2", "-Wall", "-arch", "x86_64"]
    parse_ill_short(argv, opt_h)
    assert_equal(["-fno-common", "-Os", "-stdlib=libc++", "-x", "cu", "-O2", "-Wall", "--arch", "x86_64"],
                 argv)

    h = Hash.new{|h, k| h[k] = [] }.merge({"-shared"=>[""], "-pipe"=>[""]})
    assert_equal(" --compiler-options -pipe",
                 compiler_option(h))

    opt_h = Hash.new{|h, k| h[k] = [] }
#    argv = ["--mkmf-cu-ext=cxx", "-dynamic", "-bundle", "-o", "culib.bundle", "culib.o", "-L.", "-L/opt/local/lib", "-Wl,-headerpad_max_install_names", "-fstack-protector", "-L/opt/local/lib", "-Wl,-undefined,dynamic_lookup", "-Wl,-multiply_defined,suppress", "-arch", "x86_64", "-lruby.2.3.0", "-lc++", "-lpthread", "-ldl", "-lobjc"]

    argv = ["-Wl,-headerpad_max_install_names", "-fstack-protector", "-L/opt/local/lib", "-Wl,-undefined,dynamic_lookup", "-Wl,-multiply_defined,suppress"]
    parse_ill_short_with_arg(argv, opt_h)
    assert_equal(["--Wl=-headerpad_max_install_names", "-fstack-protector", "-L/opt/local/lib", "--Wl=-undefined,dynamic_lookup", "--Wl=-multiply_defined,suppress"],
                 argv)

    h = Hash.new{|h, k| h[k] = [] }.merge({"-Wl"=>["-a", "-b"]})
    assert_equal(" --linker-options -a --linker-options -b",
                 linker_option(h))

  end

  def test_compiler_bin
    h = Hash.new{|h, k| h[k] = [] }.merge({"-shared"=>[""], "-pipe"=>[""], "--mkmf-cu-ext"=>["c"]})
    assert_equal(" --compiler-bindir " + RbConfig::CONFIG["CC"],
                 compiler_bin(h))
  end
end
