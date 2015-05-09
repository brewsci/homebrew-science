class Analysis < Formula
  homepage "https://github.com/molpopgen/analysis"
  url "https://github.com/molpopgen/analysis/archive/0.8.7.tar.gz"
  sha256 "3af7ce89358376d3d27ee97b518735ddddc7a5cb6e0b340833c8e1a44fdb34be"

  depends_on "gsl"
  depends_on "libsequence"

  # add missing include
  # https://github.com/molpopgen/analysis/pull/3
  patch do
    url "https://github.com/tdsmith/molpopgen-analysis/commit/01c796d.diff"
    sha256 "abaefd36f108f1981e28d874e4cd78ca961d07841e69b4af607d0585354c72d5"
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert shell_output("#{bin}/gestimator 2>&1", 1).include? "gestimator"
  end
end
