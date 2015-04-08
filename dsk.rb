class Dsk < Formula
  homepage "http://minia.genouest.org/dsk/"
  url "http://gatb-tools.gforge.inria.fr/versions/src/dsk-2.0.2-Source.tar.gz"
  sha256 "bf2668e583a48021ba08f65aedbe447ba41084aad58020b2d77115bc81fad47f"

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
