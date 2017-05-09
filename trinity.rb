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
    sha256 "e3e3110b6d11c3343e273e340a02ac9bd7ee4297a03a291d497625260c526fbf" => :sierra
    sha256 "50886dfe6cb1cc43305e5ed336d0a87ded6cd0eb5bae2afc40a3a024a840d79a" => :el_capitan
    sha256 "69c287be729f111eb94d51b3e6414a7467f6067063b93f1b17759290735044c1" => :yosemite
    sha256 "f7d5ae203d03cc218cf0968e728b980e9429ad28a0684cb98aae22fdbfe16c18" => :x86_64_linux
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
