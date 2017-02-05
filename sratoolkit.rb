class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  url "https://github.com/ncbi/sra-tools/archive/2.8.1-2.tar.gz"
  version "2.8.1-2"
  sha256 "98680ade0decf82a5f8de85557acd9071aa724822347eedef8b24338717504d0"
  revision 1
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    cellar :any
    sha256 "739a3c3bddc8cb5e3ab6be0e358e65f3f4075bcbab34d89eb7a5cf61327d8995" => :sierra
    sha256 "128216cdefa2cf357e6a813a1be0537806ab94695fc899230e95375d8de3e658" => :el_capitan
    sha256 "a36d0623d4be9e3d222ce3ecd022957948ef15810e8ebfbb04312eadc71e95d3" => :yosemite
    sha256 "cc56ad3a7f0066b0db89ef3afb134fb259bef4269bc5651c97512c587b87de6e" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "libxml2"
  depends_on "libmagic" => :recommended
  depends_on "hdf5" => :recommended

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/1.3.0.tar.gz"
    sha256 "803c650a6de5bb38231d9ced7587f3ab788b415cac04b0ef4152546b18713ef2"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.8.1.tar.gz"
    sha256 "5e8c03adf6305090de6aeeaa8c06df0cc8ac7b7d35e3dd6462e2d0b4788c21fa"
  end

  def install
    ENV.deparallelize

    # Linux fix: libbz2.a(blocksort.o): relocation R_X86_64_32 against `.rodata.str1.1'
    # https://github.com/Homebrew/homebrew-science/issues/2338
    ENV["LDFLAGS"]="" if OS.linux?

    resource("ngs-sdk").stage do
      cd "ngs-sdk" do
        system "./configure", "--prefix=#{prefix}",
                              "--build=#{Pathname.pwd}/ngs-sdk-build"
        system "make"
        system "make", "test"
        system "make", "install"
      end
    end

    (buildpath/"ncbi-vdb").install resource("ncbi-vdb")
    cd "ncbi-vdb" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-ngs-sdk-prefix=#{prefix}",
                            "--build=#{buildpath}/ncbi-vdb-build"
      system "make"
      system "make", "install"
    end

    inreplace "tools/copycat/Makefile", "-smagic-static", "-smagic"

    # Fix the error: undefined reference to `SZ_encoder_enabled'
    inreplace "tools/pacbio-load/Makefile", "-shdf5 ", "-shdf5 -ssz "

    system "./configure", "--prefix=#{prefix}",
                          "--with-ngs-sdk-prefix=#{prefix}",
                          "--with-ncbi-vdb-sources=#{buildpath}/ncbi-vdb",
                          "--with-ncbi-vdb-build=#{buildpath}/ncbi-vdb-build",
                          "--build=#{buildpath}/sra-tools-build"

    system "make", "VDB_SRCDIR=#{buildpath}/ncbi-vdb"
    system "make", "VDB_SRCDIR=#{buildpath}/ncbi-vdb", "install"

    rm "#{bin}/magic"
    rm_rf "#{bin}/ncbi"
    rm_rf "#{lib}64"
    rm_rf include.to_s

    pkgshare.install share/"examples"
  end

  test do
    # just download the first FASTQ read from an NCBI SRA run (needs internet connection)
    system bin/"fastq-dump", "-N", "1", "-X", "1", "SRR000001"
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
