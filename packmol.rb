class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "http://www.ime.unicamp.br/~martinez/packmol/"
  url "http://leandro.iqm.unicamp.br/packmol/versionhistory/packmol-16.320.tar.gz"
  sha256 "792df9f318189df19e9281237862c3de3cf3dc8e95c130b98ff107bf097a4243"

  bottle do
    sha256 "a15f4a9a27660103c40e3e3cac871d76a6089fc29d97b0ac4c0a2492243f93e5" => :sierra
    sha256 "8363be20800384e1e7377d8ec8e978172f42967c5cbce0a0acd23254718bb8ec" => :el_capitan
    sha256 "1fa7df4b06ae6a849fc61441a51a2f2b9a890e18ae208de4cad49188603b7dc5" => :yosemite
    sha256 "9dd880b5671fa9eb84abcecda606430150415ffdb7904c28c9684f9eaae3fe90" => :x86_64_linux
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
