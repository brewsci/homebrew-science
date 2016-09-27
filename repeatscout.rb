class Repeatscout < Formula
  homepage "http://bix.ucsd.edu/repeatscout/"
  # doi "10.1093/bioinformatics/bti1018"
  # tag "bioinformatics"

  url "http://bix.ucsd.edu/repeatscout/RepeatScout-1.0.5.tar.gz"
  sha256 "bda6f782382f2b7dcb6a004b7da586d5046b3c12429b158e24787be62de6199c"

  bottle do
    cellar :any
    sha256 "3736ad2e736c526c1b485d84fd59aaf644d371d9718fdb7ccafe59efcdbd11f4" => :yosemite
    sha256 "f77ed5e45329577b5042585d0811f6bfc42771c07c14606b5f93502967463719" => :mavericks
    sha256 "3d2fbc43ac051ac3ffe8c699b4cb702fc8841440985bb720925595c24d99b378" => :mountain_lion
    sha256 "3e23d52321796318510d560e0efb1467340c1e7221503981ddf004d10f329661" => :x86_64_linux
  end

  depends_on "trf" => :optional

  def install
    system "make"
    prefix.rmdir
    system *%W[make install INSTDIR=#{prefix}]
    bin.install_symlink "../RepeatScout"
  end

  test do
    system "#{bin}/RepeatScout 2>&1 |grep RepeatScout"
  end
end
