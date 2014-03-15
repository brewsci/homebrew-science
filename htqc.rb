require 'formula'

class Htqc < Formula
  homepage 'http://sourceforge.net/projects/htqc/'
  url 'https://downloads.sourceforge.net/project/htqc/htqc-0.90.2-Source.tar.gz'
  sha1 'c4204ed1b85d78daa3c90968b99eea113308ed72'

  depends_on 'cmake' => :build
  depends_on 'boost'

  fails_with :clang do
    build 503
    cause "error: call to constructor of 'htio::FastaIO' is ambiguous"
  end

  def install
    system 'cmake', '.', *std_cmake_args
    system 'make', 'install'
  end

  test do
    system 'ht-stat --version'
  end
end
