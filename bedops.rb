require 'formula'

class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  head 'https://github.com/bedops/bedops.git'

  url 'https://github.com/bedops/bedops/archive/v2.3.0.tar.gz'
  sha1 'ffb82320a8071af94bbf6e7d2d5834e5c8c14fc7'

  devel do
    version '2.4.1-rc1'
    url 'https://github.com/bedops/bedops/archive/v2.4.1-rc1.tar.gz'
    sha1 '436c769af8ffac70f4d7f02922915d3c71c5af88'
  end

  # Fixed in 2.4.1-rc1
  fails_with :clang do
    build 500
    cause "error: no matching constructor for initialization of 'Ext::Assert<UE>'"
  end unless build.devel? || build.head?

  fails_with :gcc do
    build 5666
    cause 'error: unrecognized command line option "-std=c++11"'
  end

  def install
    ENV.deparallelize

    # Fix for
    # error: assigning to 'struct object_key *' from incompatible type 'void *'
    # See https://github.com/Homebrew/homebrew-science/issues/666
    ENV.delete 'CC'
    ENV.delete 'CXX'

    system 'make'
    system 'make', 'install'
    bin.install Dir['bin/*']
    doc.install %w[LICENSE README.md]
  end

  test do
    system "#{bin}/bedops", '--version'
  end
end
