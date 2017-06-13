class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.163.tar.gz"
  sha256 "52b0e999fb53cb635a44fc9e2116bd9b677f524462bb43b2f793e4be55a2befb"
  head "https://github.com/leandromartinez98/packmol.git"
  # tag "chemistry"
  # doi "10.1002/jcc.21224"

  bottle do
    sha256 "9985a6c737f3d52d74728e57fc5867890c948f10e20dc8b024c0537626454fcb" => :sierra
    sha256 "61cc06222a06af226b64ddeb1d28087b193f5bc54be7d1038ddd7f0ef92ddf6b" => :el_capitan
    sha256 "ac938f42a232278e4dd2e93362ba1a052dc67fc4989bfa60883b428448e6f42d" => :yosemite
    sha256 "01894d7fd69d51151795fcd51814d488ac0d2e086b052159a2de3b90b2e8adc2" => :x86_64_linux
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
