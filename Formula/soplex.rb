class Soplex < Formula
  desc "Sequential object-oriented simPlex"
  homepage "http://soplex.zib.de"
  url "http://soplex.zib.de/download/release/soplex-3.1.0.tgz"
  sha256 "577d5719bc4c10d4b2e43222b4173fa830a050cb0ce2addd92ad5683c9fed276"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, high_sierra: "c922367d9709352c5c4d7fb119f24c0ef868189b7e0193b005bf3ba06a40ba19"
    sha256 cellar: :any, sierra:      "a06a6662c8cd61c49b27437ec927eeeccd7ab23c53382ab9581c22fee3d45c9d"
    sha256 cellar: :any, el_capitan:  "d6b36d1c9bd64cb7a7099632f6832a646d03db06acce2081dbd3e02786879c98"
  end

  option "without-test", "Skip build-time tests (not recommended)"

  depends_on "gmp"
  depends_on "zlib" if OS.linux?

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

  def caveats
    <<~EOS
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
    system ENV.cxx, "-std=c++11", "#{pkgshare}/example.cpp", "-oexample", *libs
    system "./example"
  end
end
