class Trinity < Formula
  desc "RNA-Seq de novo assembler"
  homepage "https://trinityrnaseq.github.io"
  # doi "10.1038/nbt.1883"
  # tag "bioinformatics"

  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.0.6.tar.gz"
  sha256 "e0c3ec885fdcfe3422ea492372518ddf5d1aed3daa187c69c4254516b0845de1"
  revision 1
  head "https://github.com/trinityrnaseq/trinityrnaseq.git"

  bottle :disable, "Cannot currently build with GCC-5 or Clang"

  depends_on "bowtie"
  depends_on "express" => :recommended
  depends_on "samtools"

  depends_on :java => "1.7+" unless OS.linux?

  needs :openmp

  fails_with :llvm do
    cause 'error: unrecognized command line option "-std=c++0x"'
  end

  fails_with :gcc => "5" do
    cause <<-EOS.undent
      error: no match for 'operator==' (operand types are
      'std::ifstream {aka std::basic_ifstream<char>}' and 'int')
    EOS
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
