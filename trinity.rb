class Trinity < Formula
  homepage "http://trinityrnaseq.sourceforge.net"
  #doi "10.1038/nbt.1883"
  #tag "bioinformatics"
  version "r20140717"
  url "https://downloads.sourceforge.net/trinityrnaseq/trinityrnaseq_#{version}.tar.gz"
  sha1 "fd559efe2005fb0c568b280a3edf43e25e6e6aba"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 1
    sha1 "85c2cb7c2be884a4afc6235b0d04bb8f0f0c4b97" => :yosemite
    sha1 "258c0cbab67f9c48140bccdc4e89e0e05344fc06" => :mavericks
    sha1 "7c887b6ba2875e53a508cf757ec51bdbdb8bff27" => :mountain_lion
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
