class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.099.tar.gz"
  sha256 "3ca76cd6cad933a33e2c60a956c3b21c1e9087c88daa4ab5c358b5dba67527ae"
  head "https://github.com/leandromartinez98/packmol.git"
  # tag "chemistry"
  # doi "10.1002/jcc.21224"

  bottle do
    sha256 "0e943d006e8b48dc59fa8ffc7c93a616b037f9785460b4ac81dde07eddedcd72" => :sierra
    sha256 "d4ce3e8b0eb0efaf4064c0969a55ecb86176adc0c56ed214dc023bc0f3e25fa6" => :el_capitan
    sha256 "579e1d1dc835d6f5519d4439ef35700d9db674bc945dc37549e4dd64e2dae577" => :yosemite
    sha256 "9a9cc6383b100b5e4112974916e72e8e6c2a47bb57103cfc8ec9f87f433b039b" => :x86_64_linux
  end

  depends_on :fortran

  resource "examples" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    system "./configure"
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
