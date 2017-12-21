class Masurca < Formula
  desc "Maryland Super-Read Celera Assembler"
  homepage "http://masurca.blogspot.com"
  url "ftp://ftp.genome.umd.edu/pub/MaSuRCA/latest/MaSuRCA-3.2.3.tar.gz"
  sha256 "533d8bf2225c2f7701f82093025d8a7ec8830b1c6632801e8d6a0216b84d86e6"
  # doi "10.1093/bioinformatics/btt476"
  # tag "bioinformatics"

  bottle do
    sha256 "fa77052c424949866ee9da1b27e96742ce6e93cb2d4f3093420c592bdde20f37" => :x86_64_linux
  end

  fails_with :clang do
    build 703
    cause "n50.cc:105:51: error: no member named 'ceil' in namespace 'std'"
  end

  fails_with :gcc => "6" do
    cause "n50.cc:105:51: error: no member named 'ceil' in namespace 'std'"
  end

  depends_on :linux
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

    # Conflicts with soapdenovo
    rm [bin/"SOAPdenovo-63mer", bin/"SOAPdenovo-127mer"]

    # Conflicts with jellyfish
    rm bin/"jellyfish"
    rm Dir[lib/"libjellyfish*", lib/"pkgconfig/jellyfish-2.0.pc"]
    rm_r include/"jellyfish-1"
    rm man1/"jellyfish.1"

    # Conflicts with samtools
    rm bin/"samtools"

    # Conlicts with mummer
    cd "/tmp" do
      rm %w[
        combineMUMs delta-filter dnadiff exact-tandems mummer mummerplot
        nucmer promer repeat-match show-coords show-diff show-snps show-tiling
      ]
    end
  end

  test do
    system "#{bin}/masurca", "-h"
  end
end
