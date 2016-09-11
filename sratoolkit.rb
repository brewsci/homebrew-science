class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  url "https://github.com/ncbi/sra-tools/archive/2.7.0.tar.gz"
  sha256 "274cd6c4a228c351b5e72eecf382d73d5cccde7d852940af68877883d7e1ea8e"
  revision 1

  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    cellar :any
    sha256 "1a96d18ea322b04ba8a16a7067348e4aae2f0c10824bacf1df29b1af68970b44" => :el_capitan
    sha256 "1bc7451705d5aeb7a5e5c33c02de5f28e927d50059e019d223c3085b4bb973b6" => :yosemite
    sha256 "ea2683ccec91ed246f0b25211ed08fcb50cacfb7de87f75cdac798b1f463c4c0" => :mavericks
    sha256 "e3a02a33562efce03ae8b8434200faf1d8183c53960b3aa4cfc76d8b37c3a784" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "libxml2"
  depends_on "libmagic" => :recommended
  depends_on "hdf5" => :recommended

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/1.2.5.tar.gz"
    sha256 "2a32c30d1611f8ce68aba81e5b44369969c6d32bcebc37aa41be2cdbaa76c113"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.7.0.tar.gz"
    sha256 "8e227b06dffb5894cac43c2a8d3fee50b23f4609cc6a7027951ef88d7a782c74"
  end

  def install
    ENV.deparallelize

    # Linux fix: libbz2.a(blocksort.o): relocation R_X86_64_32 against `.rodata.str1.1'
    # https://github.com/Homebrew/homebrew-science/issues/2338
    ENV["LDFLAGS"]="" if OS.linux?

    resource("ngs-sdk").stage do
      cd "ngs-sdk" do
        system "./configure", "--prefix=#{prefix}", "--build=#{prefix}"
        system "make"
        system "make", "test"
        system "make", "install"
      end
    end

    resource("ncbi-vdb").stage do
      system "./configure", "--with-ngs-sdk-prefix=#{prefix}", "--prefix=#{prefix}", "--build=#{prefix}"
      system "make"
      system "make", "install"
      (include/"ncbi-vdb").install Dir["*"]
    end

    inreplace "tools/copycat/Makefile", "-smagic-static", "-smagic"

    # Fix the error: undefined reference to `SZ_encoder_enabled'
    inreplace "tools/pacbio-load/Makefile", "-shdf5 ", "-shdf5 -ssz "

    system "./configure",
      "--prefix=#{prefix}",
      "--with-ngs-sdk-prefix=#{prefix}",
      "--with-ncbi-vdb-sources=#{include}/ncbi-vdb",
      "--with-ncbi-vdb-build=#{prefix}",
      "--build=#{prefix}"
    system "make"
    system "make", "install"
    rm "#{bin}/magic"
    rm_rf "#{bin}/ncbi"
    rm_rf "#{prefix}/sra-tools"
    rm_rf "#{prefix}/ngs-sdk"
    rm_rf "#{prefix}/ncbi-vdb"
    rm_rf "#{lib}64"
    rm_rf include.to_s
  end

  test do
    # just download the first FASTQ read from an NCBI SRA run (needs internet connection)
    system bin/"fastq-dump", "-N", "1", "-X", "1", "SRR000001"
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
