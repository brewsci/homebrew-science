class Tagdust < Formula
  desc "Generic method to extract reads from sequencing data"
  homepage "https://tagdust.sourceforge.io/"
  url "https://downloads.sourceforge.net/tagdust/files/tagdust-2.33.tar.gz"
  sha256 "8825e2975eae11e19033f233b5951517b5126bd19e049a500b1e048eaa215f84"
  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, sierra:       "03d9c2100d4c4ec058ebe172099bce03881a9c15128c36fb26dfd329151dcae0"
    sha256 cellar: :any_skip_relocation, el_capitan:   "77127e578dddb67139e381f182776bc55f4d0f3d5879285e69de42310f0ca327"
    sha256 cellar: :any_skip_relocation, yosemite:     "104cff492044c54c985e5a0f634b28703cc5607281c44cb8beb75ebcaa1a6166"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "476b38d4342f76fdb0593a5076483dc5a54bebc10a25c03d7fa21a315c102292"
  end

  # tag "bioinformatics"
  # doi "10.1186/s12859-015-0454-y"

  option "without-test", "Skip build-time tests (not recommended)"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/tagdust", "-v"
  end
end
