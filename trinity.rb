class Trinity < Formula
  desc "RNA-Seq de novo assembler"
  homepage "https://trinityrnaseq.github.io"
  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.3.2.tar.gz"
  sha256 "21421f846b4a3d3ebe69fe30d51819b32c5940a20bd4337dd98a2c8bd36a2ac3"
  head "https://github.com/trinityrnaseq/trinityrnaseq.git"

  # doi "10.1038/nbt.1883"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "d8a5a9052537469cb8b1de3908776ee4d51002c67817cc78c9b2b0941f14669e" => :sierra
    sha256 "422773fbf4fa0aeeb43c3ea7fdbe925d2696f3ae78dfbbea948da1d95e688247" => :el_capitan
    sha256 "1700f711c82f2d15a5ffa5f4132c47fab2bf96332aa7a7d9099cf77244fe7891" => :yosemite
    sha256 "a4a1e38fc0562972e578157f80b762848fe1e4b931992a4612970a0c0f31bf7c" => :x86_64_linux
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

  fails_with :llvm do
    cause 'error: unrecognized command line option "-std=c++0x"'
  end

  def install
    # Fix IRKE.cpp:89:62: error: 'omp_set_num_threads' was not declared in this scope
    ENV.append_to_cflags "-fopenmp" if OS.linux?

    inreplace "Makefile",
      "cd Chrysalis && $(MAKE)", "cd Chrysalis && $(MAKE) CC=#{ENV.cc} CXX=#{ENV.cxx}"

    inreplace "trinity-plugins/Makefile" do |s|
      s.gsub! "CC=gcc CXX=g++", "CC=#{ENV.cc} CXX=#{ENV.cxx}"
      s.gsub! /(trinity_essentials.*) jellyfish/, "\\1"
      s.gsub! /(trinity_essentials.*) trimmomatic_target/, "\\1"
      s.gsub! /(trinity_essentials.*) samtools/, "\\1"
      s.gsub! "scaffold_iworm_contigs_target: htslib_target", "scaffold_iworm_contigs_target:"
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
    inreplace "trinity-plugins/collectl/Tests.py", "/N/dc2/scratch/befulton/TrinityMason/trinityrnaseq_r20140717/trinity-plugins/jellyfish/bin/jellyfish", Formula["jellyfish"].opt_prefix
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
