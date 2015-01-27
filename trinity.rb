class Trinity < Formula
  homepage "https://trinityrnaseq.github.io"
  # doi "10.1038/nbt.1883"
  # tag "bioinformatics"
  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.0.2.tar.gz"
  sha1 "2245a03d02b2b47cee012fefe13d39d1ada4cbf0"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "f943fab33ab8fafcc2de18cfde8a8cda54179539" => :yosemite
    sha1 "5e403f71f2661dfa5e9dd74e978459f647b8559f" => :mavericks
    sha1 "f2ec7abf4d96cda7d95c05ad2f1552fda81e6f73" => :mountain_lion
  end

  depends_on "bowtie"
  depends_on "samtools-0.1"
  depends_on :java => "1.6"

  needs :openmp

  def install
    ENV.deparallelize

    # Fix IRKE.cpp:89:62: error: 'omp_set_num_threads' was not declared in this scope
    ENV.append_to_cflags "-fopenmp"

    inreplace "Trinity",
      '$ENV{TRINITY_HOME} = "$FindBin::Bin";',
      '$ENV{TRINITY_HOME} = "$FindBin::RealBin";'

    inreplace "Makefile",
      "cd Chrysalis && $(MAKE)",
      "cd Chrysalis && $(MAKE) CC=#{ENV.cc} CXX=#{ENV.cxx}"

    inreplace "trinity-plugins/Makefile",
      "CC=gcc CXX=g++", "CC=#{ENV.cc} CXX=#{ENV.cxx}"

    system "make"
    doc.install Dir["docs/*"]
    prefix.install Dir["*"]
    bin.install_symlink prefix/"Trinity"
  end

  def caveats; <<-EOS.undent
    You may need to add the following environment variable:
      export PERL5LIB=#{opt_prefix}/PerlLib:$PERL5LIB
    EOS
  end

  test do
    ohai "Testing Trinity assembly on a small data set (requires ~2GB of memory)"
    cd prefix/"sample_data/test_Trinity_Assembly" do
      system "./runMe.sh"
      system "./cleanme.pl"
    end
  end
end
