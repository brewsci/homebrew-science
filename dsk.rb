class Dsk < Formula
  desc "Low memory k-mer counting software"
  homepage "http://minia.genouest.org/dsk/"
  url "http://gatb-tools.gforge.inria.fr/versions/src/dsk-2.0.5-Source.tar.gz"
  sha256 "65e37d39d68db972f64ff65dc9948943732b240fb7854908f716de436ea0d069"

  bottle do
    cellar :any
    sha256 "8c755f6f6caaa56a85af63ce40ca20e2c3006d5ba378f5d8b1150d1822748192" => :yosemite
    sha256 "9a528fc1925499203f2feb91ba8458d6fef1a2416c3bf1445e96611f98041e29" => :mavericks
    sha256 "39b7f548c8170a07b94cc987ccdc9212a31d9341b9954c22963fa4a7ee7b9343" => :mountain_lion
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
