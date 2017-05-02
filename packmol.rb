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
    sha256 "d8ac60326c0a8ccde27e1705af846491aa7fb3de2cee87732c3b66b3a18c67ac" => :sierra
    sha256 "fbb2be0fafc1509369a3fcd146eda943c88f5710cf57dfa9f49dd0ba9ff298a4" => :el_capitan
    sha256 "e3a0c637a2d5d7331440cef080595137682f3d85a80fac0d978d22eb9f385e51" => :yosemite
    sha256 "e76dc292bdf73cecd882e786800105ea980508aff4be8c0a3cc4ecf032caadd8" => :x86_64_linux
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
