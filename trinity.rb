class Trinity < Formula
  desc "RNA-Seq de novo assembler"
  homepage "https://trinityrnaseq.github.io"
  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.4.0.tar.gz"
  sha256 "2e91ed242923205b060164398aa325e5fe824040732d86c74ece4f98d7a6f220"
  revision 1
  head "https://github.com/trinityrnaseq/trinityrnaseq.git"

  # doi "10.1038/nbt.1883"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "bf150c95d2eb1d389318857e8667e049bfe1602bd58c0cea77d52b2366951bf8" => :sierra
    sha256 "f0706afd42ffeb3d79e856c084b1f68cb3b401234290c62edc0ddf1d5c07fabd" => :el_capitan
    sha256 "026cf86ae41f3d92a4a22f07b1cb5f5ef35d0fa9a35a14da13c148cbb6a7de2c" => :yosemite
    sha256 "4970409e1ce7bad2505622c84d1b65aeec5fae0eef3c1aeaae8a54d2cc47ecb1" => :x86_64_linux
  end

  depends_on "express" => :recommended
  depends_on "bowtie2"
  depends_on "jellyfish"
  depends_on "trimmomatic"
  depends_on "samtools"
  depends_on "htslib"
  depends_on "gcc"

  depends_on :java => "1.8+"

  needs :openmp

  def install
    # Fix IRKE.cpp:89:62: error: 'omp_set_num_threads' was not declared in this scope
    ENV.append_to_cflags "-fopenmp" if OS.linux?
    ENV.append "CPPFLAGS", "-I#{buildpath}/Chrysalis"

    inreplace "Makefile",
      "cd Chrysalis && $(MAKE)", "cd Chrysalis && $(MAKE) CC=#{ENV.cc} CXX=#{ENV.cxx}"

    inreplace "trinity-plugins/Makefile" do |s|
      s.gsub! "CC=gcc CXX=g++", "CC=#{ENV.cc} CXX=#{ENV.cxx}"
      s.gsub! /(trinity_essentials.*) jellyfish/, "\\1"
      s.gsub! /(trinity_essentials.*) trimmomatic_target/, "\\1"
      s.gsub! /(trinity_essentials.*) samtools_target/, "\\1"
    end

    inreplace "Trinity" do |s|
      s.gsub! "$ROOTDIR/trinity-plugins/jellyfish", Formula["jellyfish"].opt_prefix
      s.gsub! "$ROOTDIR/trinity-plugins/Trimmomatic/trimmomatic.jar", Formula["trimmomatic"].opt_share/"java/trimmomatic-#{Formula["trimmomatic"].version}.jar"
      s.gsub! "$ROOTDIR/trinity-plugins/Trimmomatic", Formula["trimmomatic"].opt_prefix
    end

    inreplace "util/support_scripts/trinity_install_tests.sh" do |s|
      s.gsub! "trinity-plugins/jellyfish/jellyfish", Formula["jellyfish"].opt_prefix
      s.gsub! "trinity-plugins/BIN/samtools", Formula["samtools"].opt_prefix
    end

    inreplace "galaxy-plugin/old/GauravGalaxy/Trinity", "$ROOTDIR/trinity-plugins/jellyfish", Formula["jellyfish"].opt_prefix
    inreplace "galaxy-plugin/old/Trinity", "$ROOTDIR/trinity-plugins/jellyfish", Formula["jellyfish"].opt_prefix
    inreplace "util/insilico_read_normalization.pl", "$ROOTDIR/trinity-plugins/jellyfish", Formula["jellyfish"].opt_prefix
    inreplace "util/misc/run_jellyfish.pl", '$JELLYFISH_DIR = $FindBin::RealBin . "/../../trinity-plugins/jellyfish-1.1.3";',
                                            "$JELLYFISH_DIR = \"#{Formula["jellyfish"].opt_prefix}\";"

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
    Trinity only officially supports Java 1.8. To skip this check pass the
    option --bypass_java_version_check to Trinity. A specific Java version may
    also be set via environment variable:
      JAVA_HOME=`/usr/libexec/java_home -v 1.8`
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
