require "formula"

class P4est < Formula
  homepage "http://www.p4est.org"
  url "http://p4est.github.io/release/p4est-1.1.tar.gz"
  sha1 "ed8737d82ef4c97b9dfa2fd6e5134226f24c9b0b"

  head do
    url "https://github.com/cburstedde/p4est.git", :branch => "master"
    version "1.2pre"
  end

  option 'without-check', 'Skip build-time tests (not recommended)'

  depends_on :mpi => [:cc, :cxx]

  def install
    ENV['CC']       = "mpicc"
    ENV['CXX']      = "mpic++"
    ENV['CFLAGS']   = "-O2"
    ENV['CPPFLAGS'] = "-DSC_LOG_PRIORITY=SC_LP_ESSENTIAL"

    system "./configure", "--enable-mpi",
                          "--enable-shared",
                          "--disable-vtk-binary",
                          "--prefix=#{prefix}"

    system "make"
    system "make check" if build.with? "check"
    system "make install"
  end

end
