class Yices < Formula
  desc "SMT Solver"
  homepage "http://yices.csl.sri.com/"
  url "https://github.com/SRI-CSL/yices2/archive/Yices-2.5.4.tar.gz"
  sha256 "f7403328d7d0b3973ffac61fe674d5b8030dd4806c75f3de2cfb8fd81aad1ccd"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, high_sierra:  "4a7c1a5826539df6e4e1f4639e90810ca2e9b1e43272235d9e58de3d0a92d30d"
    sha256 cellar: :any, sierra:       "36423ab1afd1f3d45a96f9ba18b1936b29d3eaab0116458ef2fc62f766a5a20c"
    sha256 cellar: :any, el_capitan:   "d1ea2c2b960864d4e8373b3ce85137678ac3165f1bc9b4b6edca94412cc07d5a"
    sha256 cellar: :any, x86_64_linux: "8be5714d6dc16b4f9c2f326f703bb24e503f43dfb50a6d21c03d12ce9adea801"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "gperf"

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
    (testpath/"lra.smt2").write <<~EOS
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
