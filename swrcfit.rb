class Swrcfit < Formula
  desc "Fitting of soil water retention curve"
  homepage "http://swrcfit.sourceforge.net/"
  # doi "10.5194/hessd-4-407-2007"
  url "https://github.com/sekika/swrcfit/archive/v3.0.tar.gz"
  sha256 "bee47347bad5db0ac72597b82d5fff20278e57d5792e431f6d987c52360d7021"
  head "https://github.com/sekika/swrcfit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb876429cd9d5d10e0bd03b2559f41664410a3ff67fac19185300ea924934d4e" => :el_capitan
    sha256 "74514de98ab2bb35f82a8c23e70330d4626a1fde469e9677e6b5b98975f2aabc" => :yosemite
    sha256 "287c5fa1d803ee75401cdd657cc3f80e6c75330c3b656d11755b4bbf6245b9d6" => :mavericks
  end

  depends_on "octave"
  depends_on "wget"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/swrcfit", "-v"
  end
end
