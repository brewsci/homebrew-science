require 'formula'

class Seqdb < Formula
  homepage 'https://bitbucket.org/mhowison/seqdb'
  url 'https://bitbucket.org/mhowison/seqdb/downloads/seqdb-0.2.0.tar.gz'
  sha1 'd0bc522dee53a0560fefefebcdad53f627bcc540'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "e5ace3b70b6d8e7b06d3049af0732fa41b6630fd" => :yosemite
    sha1 "38dd2da378af6ec032fd653cd5c81510ce3dd2e6" => :mavericks
    sha1 "8d63df204b564a391d9d3fb551b887cc5dcf6d67" => :mountain_lion
  end

  needs :openmp

  depends_on 'hdf5'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "seqdb"
  end
end
