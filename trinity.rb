class Trinity < Formula
  homepage "https://trinityrnaseq.github.io"
  # doi "10.1038/nbt.1883"
  # tag "bioinformatics"

  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.0.6.tar.gz"
  sha256 "e0c3ec885fdcfe3422ea492372518ddf5d1aed3daa187c69c4254516b0845de1"
  head "https://github.com/trinityrnaseq/trinityrnaseq.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "f9541b1af75e7159212656ca4150d1a31463731f1fd750ca402f902709436c75" => :yosemite
    sha256 "519e843cd74610987b2fa6757a17b1d565d147904ceb0c0287aec1eafad90bb7" => :mavericks
    sha256 "f79aeab456fad74f45276ff723e05c14783b81083cc87ff18fa72209e7485ade" => :mountain_lion
  end

  depends_on "bowtie"
  depends_on "express"
  depends_on "samtools"

  needs :openmp

  fails_with :llvm do
    cause 'error: unrecognized command line option "-std=c++0x"'
  end

  def install
    ENV.deparallelize

    # Fix IRKE.cpp:89:62: error: 'omp_set_num_threads' was not declared in this scope
    ENV.append_to_cflags "-fopenmp"

    inreplace "Makefile",
      "cd Chrysalis && $(MAKE)", "cd Chrysalis && $(MAKE) CC=#{ENV.cc} CXX=#{ENV.cxx}"

    inreplace "trinity-plugins/Makefile",
      "CC=gcc CXX=g++", "CC=#{ENV.cc} CXX=#{ENV.cxx}"

    system "make", "all"
    system "make", "plugins"
    system "make", "test"
    prefix.install Dir["*"]

    (bin/"Trinity").write <<-EOS.undent
      #!/bin/bash
      PERL5LIB="#{prefix}/PerlLib" exec "#{prefix}/Trinity" "$@"
    EOS
  end

  def caveats; <<-EOS.undent
    Trinity only officially supports Java 1.7. To skip this check pass
    the option --bypass_java_version_check to Trinity. A specific Java version
    may also be set via environment variable:
      JAVA_HOME=`/usr/libexec/java_home -v 1.7`
    EOS
  end

  test do
    cp_r Dir["#{prefix}/sample_data/test_Trinity_Assembly/*.fq.gz"], "."
    system "#{bin}/Trinity",
      "--no_distributed_trinity_exec", "--bypass_java_version_check",
      "--seqType", "fq", "--max_memory", "1G", "--SS_lib_type", "RF",
      "--left", "reads.left.fq.gz,reads2.left.fq.gz",
      "--right", "reads.right.fq.gz,reads2.right.fq.gz"
  end
end
