class Dsk < Formula
  desc "Low memory k-mer counting software"
  homepage "http://minia.genouest.org/dsk/"
  # doi "10.1093/bioinformatics/btt020"
  # tag "bioinformatics"

  url "http://gatb-tools.gforge.inria.fr/versions/src/dsk-2.1.0-Source.tar.gz"
  sha256 "08b35e5aff5d17eb35a61b06ba7f440ae8a5a4197b72fb0a465b5ea4dd7becd0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ef63372b487dbae9e2028accb615c1c491e6b0ec392d5b994b30eb205bf7a0e" => :el_capitan
    sha256 "baa4fad7e5e2f475addc21c3963cd2829842c2d379aa65875ec61eb97f05ba0b" => :yosemite
    sha256 "06f53b2c001942c3c174d88280159b3acba0efe270aab6cae286d67f53ee47df" => :mavericks
    sha256 "d167d344def7e36febf1388b9fbba6ea303966e0597f33694c353233c075e03f" => :x86_64_linux
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
