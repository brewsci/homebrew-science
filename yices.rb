class Yices < Formula
  desc "The Yices SMT Solver"
  homepage "http://yices.csl.sri.com/"
  url "https://github.com/SRI-CSL/yices2/archive/Yices-2.5.3.tar.gz"
  sha256 "4c8972f7c257c80426f7d22473d339b5eaf8ce00ac7663f19734fa57f7fa7f28"

  bottle do
    cellar :any
    sha256 "e480423bc7fbf94a3ba512a4f672c66057905f9aaee061caf80ae84259ea0555" => :sierra
    sha256 "da027117a516e23047f3baaf6c9fe2c986434bec34c64ddeb72a11832535db5c" => :el_capitan
    sha256 "47be959ca49dd851401cc9dcddf29cf7fe0f5f9e59f8639255e405a25e51e1ca" => :yosemite
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
