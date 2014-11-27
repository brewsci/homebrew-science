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
    sha1 "0db872766335bd03e961ef7b47c83fd36312f1ce" => :yosemite
    sha1 "b66683aeb6e7456bb3009b6df6ac497e62debc46" => :mavericks
    sha1 "e7c417f0354ce0d10521d178cd11985c937b5cf1" => :mountain_lion
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on :autoconf => :build
    depends_on :automake => :build
    depends_on "multimarkdown" => :build
  end

  resource "gtest" do
    #homepage "https://code.google.com/p/googletest/"
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha1 "f85f6d2481e2c6c4a18539e391aa4ea8ab0394af"
  end

  option "without-check", "Skip build-time tests (not recommended)"

  MAXK = [32, 64, 96, 128, 256, 512]
  MAXK.each do |k|
    option "enable-maxk=#{k}", "set the maximum k-mer length to #{k}"
  end

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
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"]
    args << "--with-gtest=#{buildpath}/gtest" if build.with? "check"
    MAXK.each do |k|
      args << "--enable-maxk=#{k}" if build.include? "enable-maxk=#{k}"
    end

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/ABYSS", "--version"
  end
end
