class AllpathsLg < Formula
  homepage "http://www.broadinstitute.org/software/allpaths-lg/blog/"
  #doi "10.1073/pnas.1017351108"
  #tag "bioinformatics"

  url "ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/allpathslg-50378.tar.gz"
  sha1 "06cf7ed3ca8ed55847e895a93cf41b760a2b7021"

  fails_with :clang do
    cause "The only supported compiler is GCC(>=4.7)."
  end

  fails_with :gcc do
    build 5666
    cause "You must compile this with g++ 4.7 or higher."
  end

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/RunAllPathsLG", "--version"
  end
end
