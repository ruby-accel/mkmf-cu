# About mkmf-cu

mkmf-cu is a gem to write Ruby extention in C/C++ with NVIDIA CUDA. 
It consists of a simple wrapper command for nvcc and a monkey patch for mkmf.

## How to use it.

Instead of require "mkmf", just
```ruby
require "mkmf-cu"
```

## How does it work?

By requiring "mkmf-cu", compiler commands and a linker command defined in mkmf
will be replaced with mkmf-cu-nvcc, included in this gem.

When mkmf-cu-nvcc is called with arguments for gcc or clang,
it convert them to ones suitable for nvcc and execute nvcc with them.

For example,

    mkmf-cu-nvcc -I. -fno-common -pipe -Os -stdlib=libc++ -O2 -Wall -o culib.o -c culib.cu

will execute

    nvcc -I. -O2 -o culib.o -c culib.cu --compiler-options -fno-common \
                                        --compiler-options -stdlib=libc++ --compiler-options  -Wall
