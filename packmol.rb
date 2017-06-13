class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.163.tar.gz"
  sha256 "52b0e999fb53cb635a44fc9e2116bd9b677f524462bb43b2f793e4be55a2befb"
  head "https://github.com/leandromartinez98/packmol.git"
  # tag "chemistry"
  # doi "10.1002/jcc.21224"

  bottle do
    sha256 "8235ca0aa507410b8e040e27cc689fcdb03f0418882a48d3aac9f466bcdcb58b" => :sierra
    sha256 "86490ceaa2d2283872a9abd757411148ad387c6ae557b1e9924c5acde422b569" => :el_capitan
    sha256 "21df19c44008faca50f92b756783569cb0606fca7e753d660a814103b230b8ef" => :yosemite
    sha256 "012a65e6effc3db8a9f42fe867e6891b55b56380c0d616e1c4fcbb938c03ca08" => :x86_64_linux
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
