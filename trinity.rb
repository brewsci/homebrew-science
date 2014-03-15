require 'formula'

class Trinity < Formula
  homepage 'http://trinityrnaseq.sourceforge.net'
  version 'r20131110'
  url "https://downloads.sourceforge.net/trinityrnaseq/trinityrnaseq_#{version}.tar.gz"
  sha1 '3207147a1ece0d7f2b4b9dc5aa8e735b3d55cb1d'

  depends_on 'bowtie'

  fails_with :clang do
    build 503
    cause <<-EOS.undent
      clang does not support OpenMP, and including omp.h fails
    EOS
  end

  def install
    ENV.j1
    inreplace 'trinity-plugins/coreutils/build_parallel_sort.sh', 'make -j', 'make'

    # Build jellyfish with the desired compiler
    inreplace 'Makefile', 'CC=gcc CXX=g++', "CC=#{ENV.cc} CXX=#{ENV.cxx}"

    # Fix the undefined OpenMP symbols in parafly
    inreplace 'Makefile', 'parafly && ./configure', 'parafly && ./configure LDFLAGS=-fopenmp'

    system 'make'

    # The Makefile is designed to build in place, so we copy all of the needed
    # subdirectories to the prefix.
    prefix.install %w(Trinity.pl Inchworm Chrysalis Butterfly trinity-plugins util)

    # Trinity.pl (the main wrapper script) must remain in the prefix directory,
    # because it uses relative paths to the in-place build. So we create a
    # symlink in bin to put the wrapper in the user's path.
    mkdir_p bin
    ln_s prefix/'Trinity.pl', bin/'Trinity.pl'

    # Also install a small test case.
    (prefix + 'sample_data').install 'sample_data/test_Trinity_Assembly'
  end

  def test
    ohai "Testing Trinity assembly on a small data set (requires ~2GB of memory)"
    cd prefix/'sample_data/test_Trinity_Assembly'
    system "./runMe.sh"
    system "./cleanme.pl"
  end
end
