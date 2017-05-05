class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.099.tar.gz"
  sha256 "3ca76cd6cad933a33e2c60a956c3b21c1e9087c88daa4ab5c358b5dba67527ae"
  revision 1
  head "https://github.com/leandromartinez98/packmol.git"
  # tag "chemistry"
  # doi "10.1002/jcc.21224"

  bottle do
    sha256 "3ba0083a74c29c1249db44e5973af7add12974d6bb78951e70a54c719d19eb73" => :sierra
    sha256 "712b961a3b8f0cef6ca91ab8d3adfe6ec3e4d4205b1bda6a886393745b429a35" => :el_capitan
    sha256 "e958358ded4d70bd1483fb5f4cf5f1bff3bc6d4723c279c90505f4724c454b41" => :yosemite
    sha256 "97bc16e187a26329812dbcfdb86a0297a9b1b37900d67d47810672fc65ecdb16" => :x86_64_linux
  end

  depends_on :fortran

  resource "examples" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    system "./configure"
    # Reported upstream: https://github.com/leandromartinez98/packmol/issues/5
    inreplace "random.f90", "seed(12)", "seed(33)"
    system "make"
    bin.install("packmol")
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("examples")
  end

  test do
    %w[interface.inp water.xyz chlor.xyz t3.xyz].each { |f| cp "#{pkgshare}/examples/#{f}", testpath }
    system bin/"packmol < interface.inp"
  end
end
