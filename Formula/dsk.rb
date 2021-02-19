class Dsk < Formula
  desc "Low memory k-mer counting software"
  homepage "http://minia.genouest.org/dsk/"
  # doi "10.1093/bioinformatics/btt020"
  # tag "bioinformatics"

  url "http://gatb-tools.gforge.inria.fr/versions/src/dsk-2.1.0-Source.tar.gz"
  sha256 "08b35e5aff5d17eb35a61b06ba7f440ae8a5a4197b72fb0a465b5ea4dd7becd0"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, el_capitan:   "e5d10fdaa56b3a05c43550d8b72fcfa9b0f19c6117920b0536fd2392cdb0207c"
    sha256 cellar: :any_skip_relocation, yosemite:     "e3540a5467facb3c8a5b1f8ad369c3c9655bd891233cd04d13bd446e9da86e9e"
    sha256 cellar: :any_skip_relocation, mavericks:    "3f6fbaf148c7d5d333dde9879331036ed9ad8afa5df9f19eb33f65ca15875408"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8124115dabd9703d155bfc43c2cb8cac133621e1b62e70535144adb4b72ed162"
  end

  depends_on "cmake" => :build

  def install
    ENV.libcxx if ENV.compiler == :clang
    mkdir "build" do
      system "cmake", ".."
      system "make"
    end
    bin.install "build/dsk"
    bin.install "build/utils/dsk2ascii"
    doc.install Dir["doc/*"]
    doc.install "README.md"
  end

  test do
    (testpath/"shortread.fasta").write <<~EOS
      >taille 15
      ACTGTACGTATAAGA
    EOS
    system bin/"dsk", "-file", testpath/"shortread.fasta",
           "-kmer-size", "15", "-abundance-min", "1",
           "-out", testpath/"test_short", "-verbose", "0"
    system bin/"dsk2ascii", "-file", testpath/"test_short.h5",
           "-out", testpath/"test_short.parse_results", "-verbose", "0"
    assert_equal "ACTGTACGTATAAGA 1",
                 (testpath/"test_short.parse_results").read.chomp
  end
end
