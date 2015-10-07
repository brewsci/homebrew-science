class Dsk < Formula
  desc "Low memory k-mer counting software"
  homepage "http://minia.genouest.org/dsk/"
  # doi "10.1093/bioinformatics/btt020"
  # tag "bioinformatics"

  url "http://gatb-tools.gforge.inria.fr/versions/src/dsk-2.0.7-Source.tar.gz"
  sha256 "109f1c6e460fcc1d3a880fc0a50fc585a1dd6b4bca614d5c494582a573e5de7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ef63372b487dbae9e2028accb615c1c491e6b0ec392d5b994b30eb205bf7a0e" => :el_capitan
    sha256 "baa4fad7e5e2f475addc21c3963cd2829842c2d379aa65875ec61eb97f05ba0b" => :yosemite
    sha256 "06f53b2c001942c3c174d88280159b3acba0efe270aab6cae286d67f53ee47df" => :mavericks
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
    (testpath/"shortread.fasta").write <<-EOS.undent
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
