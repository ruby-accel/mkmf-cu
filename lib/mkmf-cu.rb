require "mkmf"

MKMF_CU = true
MakeMakefile::CONFIG["CC"]  = "mkmf-cu-nvcc --mkmf-cu-ext=c"
MakeMakefile::CONFIG["CXX"] = "mkmf-cu-nvcc --mkmf-cu-ext=cxx"
MakeMakefile::C_EXT << "cu"
MakeMakefile::SRC_EXT << "cu"

def compile_cu_with_cxx_compiler
  MakeMakefile::C_EXT.delete("cu")
  MakeMakefile::CXX_EXT << "cu"
end

def compile_cu_with_cc_compiler
  MakeMakefile::CXX_EXT.delete("cu")
  MakeMakefile::C_EXT << "cu"
end
