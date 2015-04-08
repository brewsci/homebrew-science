class Sratoolkit < Formula
  homepage "https://github.com/ncbi/sra-tools"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  url "https://github.com/ncbi/sra-tools/archive/2.4.5-5.tar.gz"
  sha256 "dabebdba7003862293eaab3b9d5f08018216338f1c389f2371220075feb6d986"
  head "https://github.com/ncbi/sra-tools.git"
  version "2.4.5-5"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "f0e076f62fe7f8f49f637d18e46dbe567bfd29122347193358903639be33ac88" => :yosemite
    sha256 "ff0903992da610367f88e53c19b86171234786f2e8c84994436bc455a8b9c4fb" => :mavericks
    sha256 "7bcf7ee41f0dd177a72a6d0c4dab9d4fa6392a2d359d1e970fcbfe4f4f5ecf99" => :mountain_lion
  end

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/1.1.0.tar.gz"
    sha256 "1ccaf90e3a4ee66662007c1e26be0e5236ecb3ad9f4f705e7a8e1ec4d39eca25"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.4.5-5.tar.gz"
    sha256 "7e1bbd203314bf65990f1db8a61483bb3963ca36a36f20f653582317cdb448b2"
  end

  depends_on "autoconf" => :build
  depends_on "libxml2"
  depends_on "libmagic" => :recommended
  depends_on "hdf5" => :recommended

  def install
    ENV.deparallelize
    resource("ngs-sdk").stage do
      cd "ngs-sdk" do
        system "./configure", "--prefix=#{prefix}", "--build=#{prefix}"
        system "make"
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

    system "./configure", "--prefix=#{prefix}", "--with-ngs-sdk-prefix=#{prefix}", "--with-ncbi-vdb-sources=#{include}/ncbi-vdb", "--with-ncbi-vdb-build=#{prefix}", "--prefix=#{prefix}", "--build=#{prefix}"
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
    system "#{bin}/fastq-dump", "--version"
  end
end
