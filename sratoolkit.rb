class Sratoolkit < Formula
  desc "Tools for using data from INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  url "https://github.com/ncbi/sra-tools/archive/2.5.2.tar.gz"
  sha256 "d128c14e13ac2e8affd3497dc59490d4932551e9524d5db697eef0951ea786f1"
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "4fc7c18f137a50a1bce786baf565295d73fce7dd76393867bd9b7210f30862e5" => :yosemite
    sha256 "11f66c21d9329765495b6c5651a5628a66f4247593895c8fc712b991a21acd48" => :mavericks
    sha256 "8a43efea621a11bb6e6f54c27ccde6bf0ee8ed12ab4a3b0fe4c42cd3bcf54336" => :mountain_lion
  end

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/1.1.3.tar.gz"
    sha256 "269c0286ed42fe00aec70d918298a0a5ca740c74189ef08fb97ee199611f13e1"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.5.2.tar.gz"
    sha256 "f10f478338f9418beab0f1e16254a3f728d7b9c6f1e2c02c2ef9512c648c0903"
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
    assert File.read("SRR000001.fastq").include?("@SRR000001.1 EM7LVYS02FOYNU length=284")
  end
end
