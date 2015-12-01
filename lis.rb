class Lis < Formula
  homepage "http://www.ssisc.org/lis"
  url "http://www.ssisc.org/lis/dl/lis-1.4.34.tar.gz"
  sha256 "e25fb5ef0c52fa0c66efab626da7d1a4b4082776173ffce632a034ab73a4d292"
  revision 1

  bottle do
    cellar :any
    sha256 "348aaa7e974831ab77f135b45ebb48ce0e0580af06eec13b360139376a17150b" => :yosemite
    sha256 "a37f461bc63941b18e2c0f1648f13ba2818e06116f9acdfae73e3a1c3d950ca2" => :mavericks
    sha256 "71604623d66bcf4d9a26baf02d3f3439393051b86b83dfae4c9521b795f7b896" => :mountain_lion
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
