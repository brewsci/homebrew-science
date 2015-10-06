class Sratoolkit < Formula
  desc "Tools for using data from INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  url "https://github.com/ncbi/sra-tools/archive/2.5.4.tar.gz"
  sha256 "452093e2fb1336cad3f8ea4c22d8a2558dd485f61a49a11493e03c321462bde7"
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    cellar :any
    sha256 "fe4809b28912bb06ee3be92ddf4a7da16a1f410afb5d2e9d4e4956cb2262cfe3" => :el_capitan
    sha256 "8f085f8475f84b7cf086898635223d9a9ba5e80f837dbb33ed64ef701bff26bc" => :yosemite
    sha256 "55a358f9781a64d7aed2d992dd76fd86d2b9943378c33e6d39657658a710f4d8" => :mavericks
  end

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/1.2.2.tar.gz"
    sha256 "b2b87ae114c463a1b3d9bbd19c54d1270341734f6b0c653e93090aee7e307867"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.5.4.tar.gz"
    sha256 "f23900884b8eea3bf1f05a7426576740fbab56c64083283897ccb5d909f396e5"
  end

  depends_on "autoconf" => :build
  depends_on "libxml2"
  depends_on "libmagic" => :recommended
  depends_on "hdf5" => :recommended

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
    rm_rf "#{bin}/ncbi"
    rm_rf "#{prefix}/sra-tools"
    rm_rf "#{prefix}/ngs-sdk"
    rm_rf "#{prefix}/ncbi-vdb"
    rm_rf "#{lib}64"
    rm_rf "#{include}"
  end

  test do
    system bin/"fastq-dump", "SRR000001"
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
