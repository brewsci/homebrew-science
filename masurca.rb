class Masurca < Formula
  desc "Maryland Super-Read Celera Assembler"
  homepage "http://masurca.blogspot.com"
  url "ftp://ftp.genome.umd.edu/pub/MaSuRCA/latest/MaSuRCA-3.2.3.tar.gz"
  sha256 "533d8bf2225c2f7701f82093025d8a7ec8830b1c6632801e8d6a0216b84d86e6"
  # doi "10.1093/bioinformatics/btt476"
  # tag "bioinformatics"

  bottle do
    sha256 "abb8cd1ad5d0333b2dfd8897effd514e31391d52d858daf58144eac1dbc96900" => :x86_64_linux
  end

  depends_on :linux

  fails_with :clang do
    build 703
    cause "n50.cc:105:51: error: no member named 'ceil' in namespace 'std'"
  end

  fails_with :gcc => "6" do
    cause "n50.cc:105:51: error: no member named 'ceil' in namespace 'std'"
  end

  depends_on "boost" => :build
  depends_on "jellyfish"
  depends_on "parallel"
  depends_on :perl => "5.18"

  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

  def install
    ENV.deparallelize
    ENV["DEST"] = prefix
    system "./install.sh"

    # Conflicts with SOAPdenovo
    rm [bin/"SOAPdenovo-63mer", bin/"SOAPdenovo-127mer"]

    # Conflicts with jellyfish
    rm bin/"jellyfish"
    rm Dir[lib/"libjellyfish*", lib/"pkgconfig/jellyfish-2.0.pc"]
    rm_r include/"jellyfish-1"
    rm man1/"jellyfish.1"

    # Conflicts with samtools
    rm bin/"samtools"

    # Conlicts with mummer
    rm bin/"combineMUMs"
    rm bin/"delta-filter"
    rm bin/"dnadiff"
    rm bin/"exact-tandems"
    rm bin/"mummer"
    rm bin/"mummerplot"
    rm bin/"nucmer"
    rm bin/"promer"
    rm bin/"repeat-match"
    rm bin/"show-coords"
    rm bin/"show-diff"
    rm bin/"show-snps"
    rm bin/"show-tiling"
  end

  test do
    system "#{bin}/masurca", "-h"
  end
end
