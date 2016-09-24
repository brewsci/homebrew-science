class Lis < Formula
  homepage "http://www.ssisc.org/lis"
  url "http://www.ssisc.org/lis/dl/lis-1.4.34.tar.gz"
  sha256 "e25fb5ef0c52fa0c66efab626da7d1a4b4082776173ffce632a034ab73a4d292"
  revision 3

  bottle do
    cellar :any
    sha256 "931659dd58dd7555990bcf001bb7ef906560ea35a315b25d40be553bb096014b" => :el_capitan
    sha256 "669a7ae326c8cb8a78358d632653503bc74eef6eaaa0d56521024708206f5317" => :yosemite
    sha256 "3b5cf44e575fd9a4cba5184597444c3b0d8f75839b9ee91753840e8a36a1dc44" => :mavericks
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
