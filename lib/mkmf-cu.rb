require "mkmf"

MakeMakefile::CONFIG["CC"]  = "mkmf-cu-nvcc --mkmf-cu-ext=c"
MakeMakefile::CONFIG["CXX"] = "mkmf-cu-nvcc --mkmf-cu-ext=cxx"
MakeMakefile::CXX_EXT << "cu"
MakeMakefile::SRC_EXT << "cu"
