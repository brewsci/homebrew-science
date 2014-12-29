require "formula"

class Prodigal < Formula
  homepage "http://prodigal.ornl.gov/"
  #doi "10.1186/1471-2105-11-119"
  #tag "bioinformatics"
  url "https://github.com/hyattpd/Prodigal/archive/v2.6.1.tar.gz"
  sha1 "aebcfbfb33010cbbba480c1db8b2ba5ebf5c7bd7"

  head "https://github.com/hyattpd/Prodigal.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "58b6b6ea89bc542585104fba63ffd5b9a1a5a52b" => :yosemite
    sha1 "cad820e17038130c8e245df756a3c3b6bf75ab72" => :mavericks
    sha1 "00c541a276de2938ffff968174c4b3076943a136" => :mountain_lion
  end

  def install
    system "make"
    mv "prodigal2", "prodigal" if build.head?
    bin.install "prodigal"
  end

  test do
    system "#{bin}/prodigal", "-v"
  end
end
