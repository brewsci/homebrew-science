class Htqc < Formula
  homepage "http://sourceforge.net/projects/htqc/"
  #doi "10.1186/1471-2105-14-33"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/htqc/htqc-0.90.2-Source.tar.gz"
  sha1 "c4204ed1b85d78daa3c90968b99eea113308ed72"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "fde8f0db51fa002e1b32fec422a74aaa120952f3" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "boost"

  fails_with :clang do
    build 600
    cause "error: call to constructor of 'htio::FastaIO' is ambiguous"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/ht-stat", "--version"
  end
end
