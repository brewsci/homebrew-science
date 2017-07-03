class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.184.tar.gz"
  sha256 "78f65b88924012ccddce4ae1977857cc35dc2d9c0f453d7c04c082815a0476b3"
  head "https://github.com/leandromartinez98/packmol.git"
  # tag "chemistry"
  # doi "10.1002/jcc.21224"

  bottle do
    sha256 "b19e029d85b92a35c5cc7f371ed531ed7635fec4187d7560e6ae6609d00b1109" => :sierra
    sha256 "0350dd15a4c14dd4dbf4911d67e678ac59d54563401399a2096d212842f03c6e" => :el_capitan
    sha256 "d3b8ccdc316f82fee7f88ad3d3afaf8305d0057414ac8cffde228c590ecf7a98" => :yosemite
    sha256 "9dd01c36f7950294119c23a5a315a84d3cbf0abea466535d0b3aa6dc2e7dba39" => :x86_64_linux
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
