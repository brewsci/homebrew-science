require 'formula'

class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  url 'https://github.com/bedops/bedops/archive/v2.4.1.tar.gz'
  sha1 '0107aac81493b22f81e139a053d32bb926d0af7b'

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
