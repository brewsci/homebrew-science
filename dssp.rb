class Dssp < Formula
  desc "Secondary structure assignments for the Protein Data Bank"
  homepage "http://swift.cmbi.ru.nl/gv/dssp/"
  url "https://mirrors.kernel.org/debian/pool/main/d/dssp/dssp_2.2.1.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dssp/dssp_2.2.1.orig.tar.gz"
  sha256 "5fb5e7c085de16c05981e3a72869c8b082911a0b46e6dcc6dbd669c9f267e8e1"
  revision 2

  bottle do
    sha256 "4af36720bc8f9f91c4affe5de5a42811596b113a05dc0326c6091e59ecc7a64b" => :el_capitan
    sha256 "e93f3dcaf703a3e5a31c057a218a224dfdbd24b627d7b57bb790278076fb174e" => :yosemite
    sha256 "c0b06eb5a524919861752c64a820e31ae4b75fbc8fee228f2b2c35782bf2ea6b" => :mavericks
  end

  depends_on "boost"

  resource "pdb" do
    url "ftp://ftp.cmbi.ru.nl/pub/molbio/data/pdb_redo/zz/3zzz/3zzz_0cyc.pdb.gz"
    sha256 "6ee5ab16972d8f3ae6c2f92fce789a40fecb1a6a8c0de42257b35fc7e9d82149"
  end

  def install
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
      system "mkdssp", "-i", "3zzz_0cyc.pdb", "-o", testpath/"test.dssp"
    end
    assert_match "POLYPYRIMIDINE TRACT BINDING PROTEIN RRM2", (testpath/"test.dssp").read
  end
end
