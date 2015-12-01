class Garli < Formula
  homepage "https://code.google.com/p/garli/"
  # tag "bioinformatics"
  url "https://garli.googlecode.com/files/garli-2.01.tar.gz"
  sha256 "e7fd4c115f9112fd9a019dcb6314e3a9d989f56daa0f833a28dc8249e50988ef"

  depends_on :mpi => :recommended
  depends_on "ncl"

  fails_with :clang do
    build 600
    cause "error: invalid operands to binary expression ('const ReconNode' and 'const ReconNode')"
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/garli", "--version"
  end
end
