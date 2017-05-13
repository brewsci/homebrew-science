class Swrcfit < Formula
  desc "Fitting of soil water retention curve"
  homepage "https://swrcfit.sourceforge.io/"
  # doi "10.5194/hessd-4-407-2007"
  url "https://github.com/sekika/swrcfit/archive/v3.0.tar.gz"
  sha256 "bee47347bad5db0ac72597b82d5fff20278e57d5792e431f6d987c52360d7021"
  revision 2
  head "https://github.com/sekika/swrcfit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "038ee703eb781065e3cd83ca746752031f827c2a43bdb2ebd80f2e199bd42263" => :sierra
    sha256 "32186215c39d14fd7df94bdacc45660d82c8d33ac1af9002d58f7090d291a896" => :el_capitan
    sha256 "7226e41b1f331e743c5c532e181e01a38603f574052250a17f4fc7f76c03271f" => :yosemite
    sha256 "bd544dae66dad4077e6f9c7b0c91f989c20f5e4d6302bb7850e6e4b42575cebb" => :x86_64_linux
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
