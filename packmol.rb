class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "http://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/16.344.tar.gz"
  sha256 "09ad18c01f46f3b1afd645bba41adcc2870f14572c7c4148962ade221241a14a"
  head "https://github.com/leandromartinez98/packmol.git"
  # tag "chemistry"
  # doi "10.1002/jcc.21224"

  bottle do
    sha256 "40e7d93b3b91fe431a66821181a076a43cea6a65242ba32f5f79ae2b601315bf" => :sierra
    sha256 "9524550fe6a36be35abd00d6611f83e1024d01772a5d5b1667678b2a1b3c8494" => :el_capitan
    sha256 "1cbb1dbf7759d118f1b05d0574986ba4861d64d813cdd8cd40f33ad8bb417081" => :yosemite
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
