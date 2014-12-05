require "formula"

class Z3 < Formula
  homepage "http://z3.codeplex.com/"
  version "4.3.1"
  url "http://download-codeplex.sec.s-msft.com/Download/SourceControlFileDownload.ashx?ProjectName=z3&changeSetId=89c1785b73225a1b363c0e485f854613121b70a7"
  sha1 "91726a94a6bc0c1035d978b225f3f034387fdfe0"
  head "https://git01.codeplex.com/z3", :using => :git

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :python

  def install
    package_dir = lib/"python2.7/site-packages"
    mkdir_p package_dir
    inreplace "scripts/mk_util.py", /^PYTHON_PACKAGE_DIR=.*/, "PYTHON_PACKAGE_DIR=\"#{package_dir}\""
    # Fixes compilation with Clang.
    inreplace "src/util/hwf.cpp", "#include<float.h>", "#include <emmintrin.h>\n#include <float.h>"

    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "python", "scripts/mk_make.py"
    cd "build" do
      system "make"
      system "make", "install"
      (share/"z3").install "test-z3"
    end
  end

  test do
    # There doesn't seem to be a convenient way to run all unit tests...
    %x[#{share}/z3/test-z3 -h].split[33..-1].each do |testcase|
      system "#{share}/z3/test-z3", testcase
    end
  end
end
