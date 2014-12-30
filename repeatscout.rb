class Repeatscout < Formula
  homepage "http://bix.ucsd.edu/repeatscout/"
  #doi "10.1093/bioinformatics/bti1018"
  #tag "bioinformatics"

  url "http://repeatscout.bioprojects.org/RepeatScout-1.0.5.tar.gz"
  sha1 "507fe8813de341244c5380836ddcf4257bb46c81"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "99cab9bddcdc39c7e0e7aca2cdb4c850bf64c460" => :yosemite
    sha1 "cef581a1b57c329eb1730dc1b669ae86005fcc7f" => :mavericks
    sha1 "51ba7be2837631c8748bfab9d06e63f1cca3756f" => :mountain_lion
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
