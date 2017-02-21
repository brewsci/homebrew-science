class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "http://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.039.tar.gz"
  sha256 "5ca717db5bee281367c6fd7dec8562be07498dab01e4b3991ad33c25b9334d9a"
  head "https://github.com/leandromartinez98/packmol.git"
  # tag "chemistry"
  # doi "10.1002/jcc.21224"

  bottle do
    sha256 "9fcf088c59c42f2e34e8a6312095c4bad7099ad012b0f8c07830a833e1ac0bc2" => :sierra
    sha256 "8abcb72b9a20630fd9f9ca6c1c8704ad1bc0588859bb7b056aa2510f34b8e95a" => :el_capitan
    sha256 "72d790f6e05693ebd87562282dc94a40537376cb5b0dc33a1747adaffb00e470" => :yosemite
    sha256 "f9ca0eb5a51156a45080e3391667abf33a3ae4e9e39986b5a2235abee6bf7198" => :x86_64_linux
  end

  depends_on :fortran

  resource "examples" do
    url "http://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
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
