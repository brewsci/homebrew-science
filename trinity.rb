class Trinity < Formula
  homepage "https://trinityrnaseq.github.io"
  # doi "10.1038/nbt.1883"
  # tag "bioinformatics"

  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.0.4.tar.gz"
  sha1 "c61ea4871d2b5e45f9df9e547c20ec5da0cb340b"
  head "https://github.com/trinityrnaseq/trinityrnaseq.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "4c38cb6610458242a852235c37757f32704e79e5" => :yosemite
    sha1 "646fc5748695990169f5746fe5282a6d1050597c" => :mavericks
    sha1 "379cb5539e180110385a165a6d8b3b6e44ee5eb1" => :mountain_lion
  end

  depends_on "bowtie"
  depends_on "express"
  depends_on "samtools"
  depends_on :java => "1.7"

  needs :openmp

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
