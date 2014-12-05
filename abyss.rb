require "formula"

class Abyss < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  #doi "10.1101/gr.089532.108"
  #tag "bioinformatics"
  url "https://github.com/bcgsc/abyss/releases/download/1.5.2/abyss-1.5.2.tar.gz"
  sha1 "f28189338efdee0167cf73f92b43181caccd2b1d"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 1
    sha1 "c8776cb322adf97f681cf861b50cc7446e61882a" => :yosemite
    sha1 "42dad6232c616687f85d654c92c8a4bb7647e3e7" => :mavericks
    sha1 "ddb43b491782dbd7a50cf82a88f486857beebe8b" => :mountain_lion
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  resource "gtest" do
    #homepage "https://code.google.com/p/googletest/"
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha1 "f85f6d2481e2c6c4a18539e391aa4ea8ab0394af"
  end

  option "enable-maxk=", "Set the maximum k-mer length to N [default is 96]"
  option "without-check", "Skip build-time tests (not recommended)"

  # Only header files are used from these packages, so :build is appropriate
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on :mpi => [:cc, :recommended]

  # strip breaks the ability to read compressed files.
  skip_clean "bin"

  def install
    resource("gtest").stage do
      system "make", "-C", "make"
      (buildpath/"gtest").install "include"
      (buildpath/"gtest/lib").install "make/gtest_main.a" => "libgtest_main.a"
    end if build.with? "check"

    system "./autogen.sh" if build.head?

    args = [
      "--enable-maxk=#{ARGV.value("enable-maxk") || 96}",
      "--prefix=#{prefix}",
      "--disable-dependency-tracking"]
    args << "--with-gtest=#{buildpath}/gtest" if build.with? "check"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/ABYSS", "--version"
  end
end
