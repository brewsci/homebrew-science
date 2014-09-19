class Trinity < Formula
  homepage "http://trinityrnaseq.sourceforge.net"
  #doi "10.1038/nbt.1883"
  #tag "bioinformatics"
  version "r20140717"
  url "https://downloads.sourceforge.net/trinityrnaseq/trinityrnaseq_#{version}.tar.gz"
  sha1 "fd559efe2005fb0c568b280a3edf43e25e6e6aba"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "1223d87371681fb7f2d4c055fd097429d0f64a74" => :yosemite
    sha1 "9564cd54b08ad3eae5d23a5dc18d44ed8a28189a" => :mavericks
    sha1 "c58dc97ac2fd157dd868977ed8ced573ff814dd7" => :mountain_lion
  end

  depends_on "bowtie"
  depends_on "samtools-0.1"
  depends_on :java => "1.6"

  needs :openmp

  def install
    inreplace "Trinity",
      "$ENV{TRINITY_HOME} = \"$FindBin::Bin\";",
      "$ENV{TRINITY_HOME} = \"#{opt_prefix}\";"

    inreplace "Makefile",
      "Chrysalis && $(MAKE)",
      "Chrysalis && make CC=#{ENV.cc} CXX=#{ENV.cxx} CFLAGS=#{ENV.cflags}"

    inreplace "trinity-plugins/Makefile" do |s|
      # Build jellyfish with the desired compiler
      s.gsub! "CC=gcc CXX=g++", "CC=#{ENV.cc} CXX=#{ENV.cxx}"
      s.gsub! "parafly && ./configure", "parafly && ./configure LDFLAGS=-fopenmp"
    end

    ENV.j1
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
