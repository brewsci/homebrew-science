class Methpipe < Formula
  homepage "http://smithlabresearch.org/software/methpipe/"
  url "http://smithlabresearch.org/downloads/methpipe-3.4.2.tar.bz2"
  sha256 "9dab70723f71af815a058d38abc963dcb43b2e25968e12dbcf17413512ededf7"
  revision 1

  head "https://github.com/smithlabcode/methpipe.git"

  bottle do
    cellar :any
    sha256 "c3c742dbab1ffd33cb04eb126821d676d265dfe3b09fa40e053db66b57515db3" => :el_capitan
    sha256 "b0496ecd2c1a9c44427eff71a784c25b9db07e5934ac27014afb57ec86404df2" => :yosemite
    sha256 "5d56e86ae7b48ecb39a15d77a61f94cb60dadfa82df08deddfd58acca19a96ab" => :mavericks
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
