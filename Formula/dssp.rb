class Dssp < Formula
  desc "Secondary structure assignments for the Protein Data Bank"
  homepage "http://swift.cmbi.ru.nl/gv/dssp/"
  url "https://mirrors.kernel.org/debian/pool/main/d/dssp/dssp_3.0.0.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dssp/dssp_3.0.0.orig.tar.gz"
  sha256 "25d39a2107767b622a59dd9fa790112c1516564b8518fc6ac0fab081d5ac3ab0"

  bottle do
    sha256 "98a4c699451b212d3122a6078bd57f70c9e55f98655752a40abfed618f23533f" => :high_sierra
    sha256 "a794e955d8d59b7c5e94f9259154e99ade3fe104b31a9eb7e98a71a39bf3ba38" => :sierra
    sha256 "01a2dd97790b3234e22a0afe5b08fb8072922749aaf1457f9c64e509e0d4c11f" => :el_capitan
    sha256 "ed18ff082794b74f61e28152d1401642f686a7c8e961843543069c856eb6a604" => :x86_64_linux
  end

  depends_on "boost"

  resource "pdb" do
    url "ftp://ftp.cmbi.ru.nl/pub/molbio/data/pdb_redo/zz/3zzz/3zzz_0cyc.pdb.gz"
    sha256 "970c00f922829fb3b2de50aee191027c16069a1a50d2ae594175010674f08c33"
  end

  # use C++11 instead off std::tr1 for Boost >= 1.65 compat
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3f14733/dssp/boost165.diff"
    sha256 "dddc01d4fe8263d32dab7b3ffd32f02859414a97bbc1d4688557dd493d93c4a6"
  end

  needs :cxx11

  def install
    ENV.cxx11

    # Create a make.config file that contains the configuration for boost
    boost = Formula["boost"].opt_prefix
    File.open("make.config", "w") do |makeconf|
      makeconf.puts "BOOST_LIB_SUFFIX = -mt"
      makeconf.puts "BOOST_LIB_DIR = #{boost}/lib"
      makeconf.puts "BOOST_INC_DIR = #{boost}/include"
    end

    # There is no need for the build to be static and static build causes
    # an error: ld: library not found for -lcrt0.o
    inreplace "makefile", "-static", ""

    system "make", "install", "DEST_DIR=#{prefix}", "MAN_DIR=#{man1}"
  end

  test do
    resource("pdb").stage do
      system bin/"mkdssp", "-i", "3zzz_0cyc.pdb", "-o", testpath/"test.dssp"
    end
    assert_match "POLYPYRIMIDINE TRACT BINDING PROTEIN RRM2", (testpath/"test.dssp").read
  end
end
