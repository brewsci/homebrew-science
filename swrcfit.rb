class Swrcfit < Formula
  desc "Fitting of soil water retention curve"
  homepage "http://swrcfit.sourceforge.net/"
  # doi "10.5194/hessd-4-407-2007"
  url "https://github.com/sekika/swrcfit/archive/v2.1.tar.gz"
  sha256 "a6038544e58db6ae7e7c310cd6537ca4509a059035667834f4b6105e0b76c1d8"

  head "https://github.com/sekika/swrcfit.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "77219e3af8a12a5a6e8bda365f59149e1c40f1c8fca5fa390d8bf9361a48b580" => :el_capitan
    sha256 "8876931c4ca1a5b7a372f2570719f9374cc9ac9b0eeac1851ee85a01620846a0" => :yosemite
    sha256 "d49f6726358d66d28af8a4ac4addb15ae2e5a331e2dfb54112ca7083a4ee994e" => :mavericks
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
