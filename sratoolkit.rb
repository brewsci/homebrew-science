class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  url "https://github.com/ncbi/sra-tools/archive/2.8.0-2.tar.gz"
  version "2.8.0-2"
  sha256 "ada344f4dc0bb438b9d594c3cc6abc156bd99d9a77c24932e8dbaad3d55af9c6"
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "17f6f8d2b3054923c520b909f260beb97fc8b91b6634e4d5a684b76f04a4344d" => :sierra
    sha256 "5321c2662affedeaeb804c44614e64009f291164c586ca2f143f87b0d397e472" => :el_capitan
    sha256 "2d27d3cb7121b36430204060b17925932cbe2c96eeed01ba41c282a57765fb7a" => :yosemite
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
    url "https://github.com/ncbi/ncbi-vdb/archive/2.8.0.tar.gz"
    sha256 "efa0b9b4987db7ef80e2c91ba35f5a0bab202e3a4824e8f34c51de303ca4eb17"
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
