class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  url "https://github.com/ncbi/sra-tools/archive/2.8.2-2.tar.gz"
  version "2.8.2-2"
  sha256 "697ed45653aa24e8bf23cfe0c68150be8a8102d450a06783fad6cc69e7243c69"
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    cellar :any
    sha256 "b566f7a182e266f6d2086fb8b58b5d74f86a4330631be67a05dda99c3bd2e9e3" => :sierra
    sha256 "177a2cfa74a3bfed01a16b2eb6ed15e967e972a4968bcc07bfb8fbcb636b417e" => :el_capitan
    sha256 "5890289978739c34c789a469df28b80d71e2a68b5aa72f1394993f9bbba734b5" => :yosemite
    sha256 "600a259c23495343fedcbff2b56de66f8867d070e342f32b5e3d04462f91a260" => :x86_64_linux
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
    url "https://github.com/ncbi/ncbi-vdb/archive/2.8.2-2.tar.gz"
    version "2.8.2-2"
    sha256 "7866f7abf00e35faaa58eb3cdc14785e6d42bde515de4bb3388757eb0c8f3c95"
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
