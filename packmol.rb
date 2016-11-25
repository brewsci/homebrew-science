class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "http://www.ime.unicamp.br/~martinez/packmol/"
  url "http://leandro.iqm.unicamp.br/packmol/versionhistory/packmol-16.320.tar.gz"
  sha256 "792df9f318189df19e9281237862c3de3cf3dc8e95c130b98ff107bf097a4243"

  bottle do
    sha256 "b25ccbf70892ede3b1a42a85c8c3d29eb5a90552a3cfdd1b3e09626f3a85ae72" => :sierra
    sha256 "d9dd3d8b3774581542c169b387bcef844af1defdd2d072a1f77a2a5d25d23966" => :el_capitan
    sha256 "3c56e147cd61f1897791b043ef5b090d73db299cc041cd7b4fe19587243ff686" => :yosemite
    sha256 "4f8db81edbf0a52fe134ddf3d5810bf98858a4c061c3430e4b5bf6d51ef2edb2" => :x86_64_linux
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
