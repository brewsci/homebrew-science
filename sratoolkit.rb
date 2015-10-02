class Sratoolkit < Formula
  desc "Tools for using data from INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  # doi "10.1093/nar/gkq1019"
  # tag "bioinformatics"

  url "https://github.com/ncbi/sra-tools/archive/2.5.2.tar.gz"
  sha256 "d128c14e13ac2e8affd3497dc59490d4932551e9524d5db697eef0951ea786f1"
  head "https://github.com/ncbi/sra-tools.git"
  revision 1

  bottle do
    cellar :any
    sha256 "fe4809b28912bb06ee3be92ddf4a7da16a1f410afb5d2e9d4e4956cb2262cfe3" => :el_capitan
    sha256 "8f085f8475f84b7cf086898635223d9a9ba5e80f837dbb33ed64ef701bff26bc" => :yosemite
    sha256 "55a358f9781a64d7aed2d992dd76fd86d2b9943378c33e6d39657658a710f4d8" => :mavericks
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
