class Methpipe < Formula
  homepage "http://smithlabresearch.org/software/methpipe/"
  url "http://smithlabresearch.org/downloads/methpipe-3.4.2.tar.bz2"
  sha256 "9dab70723f71af815a058d38abc963dcb43b2e25968e12dbcf17413512ededf7"
  revision 1

  head "https://github.com/smithlabcode/methpipe.git"

  bottle do
    cellar :any
    sha256 "dedef344060bdab246e7e4eb5f029ce893ee35e9b5d18fc1ec2d5e3108197321" => :el_capitan
    sha256 "29b86e612cff2f85b44f32cc23f64852174a5d5714c0dbdc44e198ed60ddd74a" => :yosemite
    sha256 "50d0dbec1ca1b6d5dca2743322788e4e1a5f9b9b101855d30295a61e78b860d7" => :mavericks
  end

  depends_on "gsl"

  def install
    system "make", "all"
    system "make", "install"
    prefix.install "bin"
  end

  test do
    system "#{bin}/symmetric-cpgs", "-about"
  end
end
