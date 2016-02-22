require "optparse"
require "rbconfig"
require "open3"


def build_optparser
  
  opt = OptionParser.new
  opt_h = Hash.new{|h, k| h[k] = [] }

  opt.on('-I path') {|v| opt_h["-I"] << v }
  opt.on('-D flag') {|v| opt_h["-D"] << v }
  opt.on('-W flag') {|v| opt_h["-W"] << v }
  opt.on('-o output') {|v| opt_h["-o"] << v }
  opt.on('-c file') {|v| opt_h["-c"] << v }
  opt.on('-f flag') {|v| opt_h["-f"] << v }
  opt.on('-l file') {|v| opt_h["-l"] << v }
  opt.on('-L path') {|v| opt_h["-L"] << v }
  opt.on('-x pat', "--x pat") {|v| opt_h["-x"] << v }
  opt.on('-O num'){|v| opt_h["-O"] << v if /[0-9]/ =~ v }
  opt.on('--mkmf-cu-ext ext'){|v| opt_h["--mkmf-cu-ext"] << v}
  return [opt, opt_h]
end

def parse_ill_short(argv, opt_h)
  ["-arch", "-shared", "-rdynamic", "-dynamic", "-bundle", "-stdlib", "-pipe"].each{|opt|
  if ind = argv.find_index(opt)
    if "-arch" == opt
      opt_h[opt] << "-arch," + argv[ind+1]
      argv.delete_at(ind)
      argv.delete_at(ind)
    else
      opt_h[opt] << ""
      argv.delete_at(ind)
    end
  end
  }
end

def parse_ill_short_with_arg(argv, opt_h)  
  added = []
  argv.each_with_index{|e, i|
    if /\A\-stdlib=.*/ =~ e
      added << e
      opt_h["-stdlib"] << e
    elsif /\A\-Wl,(.*)/ =~ e
      added << e
      opt_h["-Wl"] << $1
    end
  }
  added.each{|e|
    argv.delete(e)
  }
end

def compiler_option(opt_h)
  ret = ""
  ["-f", "-W", "-pipe"].each{|op|
    opt_h[op].each{|e|
      ret << " --compiler-options " + "#{op}#{e}"
    }
  }
  ["-stdlib"].each{|op|
    opt_h[op].each{|e|
      ret << " --compiler-options " + e
    }
  }
  return ret
end

def linker_option(opt_h)
  ret = ""
  ["-dynamic", "-bundle", "-shared", "-rdynamic"].each{|op|
    opt_h[op].each{|e|
      ret << " --linker-options " + op
    }
  }

  opt_h["-Wl"].each{|e|
    ret << " --linker-options " + e
  }

  return ret
end

def generate_compiling_command_line(opt_h)
  s = ""
  ["-x", "-I", "-D", "-o", "-c", "-O"].each{|op|
    opt_h[op].each{|e|
      case op
      when "-o", "-c", "-x"
        s << " #{op} #{e}"
      else
        s << " #{op}#{e}"
      end
    }
  }
  s << compiler_option(opt_h)

  if opt_h["--mkmf-cu-ext"][0] == "c"
    s << " --compiler-bindir " + RbConfig::CONFIG["CC"]
  elsif opt_h["--mkmf-cu-ext"][0] == "cxx"
    s << " --compiler-bindir " + RbConfig::CONFIG["CXX"]
  end

  return s
end

def generate_linking_command_line(argv, opt_h)
  s = ""
  ["-L", "-l", "-o", "-c", "-O"].each{|op|
    opt_h[op].each{|e|
      case op
      when "-o", "-c"
        s << " #{op} #{e}"
        s << " " + argv[0] + " " if op == "-o"
      else
        s << " #{op}#{e}"
      end
    }
  }
  s << compiler_option(opt_h)
  s << linker_option(opt_h)

  if opt_h["--mkmf-cu-ext"][0] == "c"
    s << " --compiler-bindir " + RbConfig::CONFIG["CC"]
  elsif opt_h["--mkmf-cu-ext"][0] == "cxx"
    s << " --compiler-bindir " + RbConfig::CONFIG["CXX"]
  end

  return s
end
