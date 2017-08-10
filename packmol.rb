class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.221.tar.gz"
  sha256 "b5dcdeb694ffc17f620a4517e4eba67018145774d6fa06c4076bfbfe79400407"
  head "https://github.com/leandromartinez98/packmol.git"
  # tag "chemistry"
  # doi "10.1002/jcc.21224"

  bottle do
    sha256 "b60dd9771e8198034888a63947973315ecfab336fbfe16f70d9f84c09556b6c5" => :sierra
    sha256 "8d99db0a2262aa1ac39f7710676a13280d5e9dcbff2d176c8296e739870ea2f6" => :el_capitan
    sha256 "293ae86f1ea384c881b762492676e67e8cc40f1b061a128440779c43ded39eaf" => :yosemite
    sha256 "db243a97606fb5c9aca19dc4313a4be94f439b05dad60dc84015d22f32b9e994" => :x86_64_linux
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
