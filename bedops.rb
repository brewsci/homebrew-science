require 'formula'

class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  url 'https://github.com/bedops/bedops/archive/v2.4.2.tar.gz'
  sha1 '3b67d65c40105dd17771378e18f16eac0688c652'

  head 'https://github.com/bedops/bedops.git'

  env :std

  fails_with :gcc do
    build 5666
    cause 'BEDOPS toolkit requires a C++11 compliant compiler'
  end

  def install
    ENV.O3
    ENV.deparallelize
    ENV.delete('CFLAGS')
    ENV.delete('CXXFLAGS')
    system 'make', 'build_all_darwin_intel_fat'
    system 'make', 'install'
    bin.install Dir['bin/*']
    doc.install %w[LICENSE README.md]
  end

  test do
    system "#{bin}/bedops", '--version'
  end
end
