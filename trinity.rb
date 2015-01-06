class Trinity < Formula
  homepage "http://trinityrnaseq.sourceforge.net"
  #doi "10.1038/nbt.1883"
  #tag "bioinformatics"
  version "r20140717"
  url "https://downloads.sourceforge.net/trinityrnaseq/trinityrnaseq_#{version}.tar.gz"
  sha1 "fd559efe2005fb0c568b280a3edf43e25e6e6aba"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "6fffae7cbeab4f17ac981dbf6b25433d1d01085c" => :yosemite
    sha1 "d29d8b56536dd2324ae194999b13fa083ab6e0ba" => :mavericks
    sha1 "ad9b159ad9308c1237b6f3d12f77b53283337f4b" => :mountain_lion
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
