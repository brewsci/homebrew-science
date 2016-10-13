class Soplex < Formula
  desc "The Sequential object-oriented simPlex"
  homepage "http://soplex.zib.de"
  url "http://soplex.zib.de/download/release/soplex-2.2.1.tgz"
  sha256 "c2fffca4095c56f7261820dc2bcc2a31a6a6ff91446a9da083814a913a2a086f"

  bottle do
    cellar :any
    sha256 "41d33e7eb2e439d46876b992c58588b46a15dab29c84dbc2e09d8f6d0173fae6" => :sierra
    sha256 "1babfb72fc28968f150f346011b2fca9df0a534e4cc32b9b7d0914002e99abf7" => :el_capitan
    sha256 "e5948d3b0653c07e528423792f2133ea5046676d7eb12c8ed8f042e5c9a18db4" => :yosemite
  end

  option "without-test", "Skip build-time tests (not recommended)"

  depends_on "zlib" if OS.linux?
  depends_on "gmp"

  def install
    if OS.mac?
      File.open("make/make.darwin.x86_64.clang", "a") do |f|
        f.puts "LIBBUILDFLAGS+= -m64 -lgmp -lz"
      end
    end
    make_args = ["SHARED=true", "COMP=#{ENV["CC"]}"]
    system "make", *make_args
    system "make", "test", *make_args if build.with? "test"
    system "make", "install", "INSTALLDIR=#{prefix}", *make_args
    pkgshare.install "src/example.cpp"
  end

  def caveats; <<-EOS.undent
      SoPlex is distributed under the ZIB Academic License
      (http://scip.zib.de/academic.txt).
      You are allowed to retrieve SoPlex for research purposes as a member of
      a non-commercial and academic institution.

      We agreed to this license for you.
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    libs = ["-lsoplex", "-lz", "-lgmp"]
    system ENV["CXX"], "#{pkgshare}/example.cpp", "-oexample", *libs
    system "./example"
  end
end
