class Fsa < Formula
  homepage "http://fsa.sourceforge.net/"
  # doi "10.1371/journal.pcbi.1000392"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/fsa/fsa-1.15.9.tar.gz"
  sha256 "6ee6e238e168ccba0d51648ba64d518cdf68fa875061e0d954edfb2500b50b30"

  bottle do
    cellar :any
    sha256 "2c1b0de0c38480c7818db3c032c79f818e20dae1035da6ac138fdb14f1454e93" => :yosemite
    sha256 "771dd32750e74a3e94215693b8fa2c14e79a3ed5641c7016075b3da67999a434" => :mavericks
    sha256 "32753a10cdcfe7650670170c245ba19535946cbc617f402258ab934016b00d63" => :mountain_lion
    sha256 "f56480ba967e02d02bc3bc0e4aa71acdca2c1eb983f407d370020b3fbf1f1a7c" => :x86_64_linux
  end

  depends_on "mummer" => :recommended

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fsa", "--version"
  end
end
