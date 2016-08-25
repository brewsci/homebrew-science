class Lis < Formula
  homepage "http://www.ssisc.org/lis"
  url "http://www.ssisc.org/lis/dl/lis-1.4.34.tar.gz"
  sha256 "e25fb5ef0c52fa0c66efab626da7d1a4b4082776173ffce632a034ab73a4d292"
  revision 3

  bottle do
    cellar :any
    sha256 "4347e7169640064e07ff2c191a52dd2c788ca4b5bce8e21ad56c2a847c32be9c" => :el_capitan
    sha256 "ea4fe78d212bae4166fbfdacb744423d8ab220b541665c92c26f1912db5bd1a8" => :yosemite
    sha256 "26755c99879002b4019f514db0467218be9d06b163a51cdbec08f7c965ec28b8" => :mavericks
  end

  option "without-check", "Skip build-time checks (not recommended)"
  option "with-saamg",    "build SA-AMG preconditioner"
  option "with-quad",     "enable quadruple precision operations"

  depends_on :fortran => :recommended
  depends_on :mpi => [:cc, :cxx, :f77, :f90, :recommended]

  def install
    ENV.deparallelize

    args = %W[ --prefix=#{prefix} --disable-dependency-tracking --enable-shared]
    args << "--enable-fortran" if build.with? :fortran
    args << "--enable-mpi"     if build.with? :mpi
    args << "--enable-omp" unless ENV.compiler == :clang
    args << "--enable-saamg"   if build.with? "saamg"
    args << "--enable-quad"    if build.with? "quad"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
