class Wcstools < Formula
  desc "Tools for using World Coordinate Systems (WCS) in astronomical images"
  homepage "http://tdc-www.harvard.edu/wcstools/"
  url "http://tdc-www.harvard.edu/software/wcstools/wcstools-3.9.5.tar.gz"
  sha256 "b2f9be55fdec29f0c640028a9986771bfd6ab3d2f633953e4c7cc3b410e5fe9c"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, high_sierra:  "b0b7badef0e5ca704231f4e02ac72c4a4b26e165c40a48516ebd6e745eb17b13"
    sha256 cellar: :any_skip_relocation, sierra:       "e2dec9afd018c2cfa774d4a7f948160ecd51560a310a8b60b940e43db8f388ae"
    sha256 cellar: :any_skip_relocation, el_capitan:   "981435e5ae21235f080c7a5bdf750d51e4be3b0090ac2b2ebbd62bc5371a552b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a4aaf0b6b8deed563fe758a28f476f130f77c9739ff0e5beeeffdf43e87c1424"
  end

  def install
    system "make", "-f", "Makefile.osx", "all"

    prefix.install "bin"
  end

  test do
    assert_match "IMHEAD", shell_output("#{bin}/imhead 2>&1", 1)
  end
end
