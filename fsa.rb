class Fsa < Formula
  homepage "http://fsa.sourceforge.net/"
  #doi "10.1371/journal.pcbi.1000392"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/fsa/fsa-1.15.9.tar.gz"
  sha1 "457aee5baca17357e52041eac7e3ecbc226bea75"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "de201cdf3bb5b3fec6e517993e977de341c54a92" => :yosemite
    sha1 "03486aadcae599e5846fa94b13887e85c5d1ee12" => :mavericks
    sha1 "f443a3d8b8fc5c35256cd4409df1ffc2d7a8f5c0" => :mountain_lion
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
