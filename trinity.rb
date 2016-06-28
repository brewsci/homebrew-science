class Trinity < Formula
  desc "RNA-Seq de novo assembler"
  homepage "https://trinityrnaseq.github.io"
  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.2.0.tar.gz"
  sha256 "f34603e56ac76a81447dd230b31248d5890ecffee8ef264104d4f1fa7fe46c9e"
  revision 1

  head "https://github.com/trinityrnaseq/trinityrnaseq.git"

  # doi "10.1038/nbt.1883"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "e0ede844281630b088be3dc1b0983e02aa9307a866ebdbc6320e1d596c142a70" => :el_capitan
    sha256 "9a6653a4b288245afcf0e71c024a51a8a8325e5ac54e9252920ff021efa7db37" => :yosemite
    sha256 "5902d884766d2bb88b252e64be063374b17a0d62274c7a26229d46a5e4576d65" => :mavericks
  end

  depends_on "express" => :recommended
  depends_on "bowtie" => :run
  depends_on "jellyfish" => :run
  depends_on "trimmomatic" => :run
  depends_on "samtools" => :run
  depends_on "htslib"
  depends_on "gcc"

  depends_on :java => "1.7+"

  needs :openmp

  fails_with :llvm do
    cause 'error: unrecognized command line option "-std=c++0x"'
  end

  # Teach Chrysalis's Makefile that GCC 6 exists otherwise it can't find headers
  # Reported 26 Jun 2016: https://github.com/trinityrnaseq/trinityrnaseq/pull/154
  patch do
    url "https://github.com/trinityrnaseq/trinityrnaseq/pull/154.patch"
    sha256 "8166ffebdff65ec344eda08f9104f3303616b02b2db677f0a34774ab2d022850"
  end

  def install
    ENV.deparallelize

    # Fix IRKE.cpp:89:62: error: 'omp_set_num_threads' was not declared in this scope
    ENV.append_to_cflags "-fopenmp"

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
      s.gsub! "trinity-plugins/jellyfish/jellyfish", Formula["jellyfish"].prefix
      s.gsub! "trinity-plugins/BIN/samtools", Formula["samtools"].prefix
    end

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
    Trinity only officially supports Java 1.7. To skip this check pass the
    option --bypass_java_version_check to Trinity. A specific Java version may
    also be set via environment variable:
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
