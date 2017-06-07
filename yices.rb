class Yices < Formula
  desc "The Yices SMT Solver"
  homepage "http://yices.csl.sri.com/"
  url "https://github.com/SRI-CSL/yices2/archive/Yices-2.5.2.tar.gz"
  sha256 "80a2a9f258a561b068557bdbc7a7ab630bf4acf6ff9675cbffe4423a4ac04a2b"

  bottle do
    cellar :any
    sha256 "21c4912d4b5a632d252a90352a91463f7d9bb96add62b82d8bcbf43256b27cbb" => :sierra
    sha256 "614796d70880e4a7b6ce3ac78ba98697bd9dd6d0084d8a6c1f6f61c943e0fc5f" => :el_capitan
    sha256 "1a47b5478c6645432615c70a0742f9a2508121e40f7db8a01c85aee4a90d507b" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "autoconf" => :build
  depends_on "gperf"
  depends_on "gmp"

  def install
    system "autoconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"lra.smt2").write <<-EOS.undent
      ;; QF_LRA = Quantifier-Free Linear Real Arithemtic
      (set-logic QF_LRA)
      ;; Declare variables x, y
      (declare-fun x () Real)
      (declare-fun y () Real)
      ;; Find solution to (x + y > 0), ((x < 0) || (y < 0))
      (assert (> (+ x y) 0))
      (assert (or (< x 0) (< y 0)))
      ;; Run a satisfiability check
      (check-sat)
      ;; Print the model
      (get-model)
    EOS

    assert_match "sat\n(= x 2)\n(= y (- 1))\n", shell_output("#{bin}/yices-smt2 lra.smt2")
  end
end
