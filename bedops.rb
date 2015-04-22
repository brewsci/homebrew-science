class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  #doi "10.1093/bioinformatics/bts277"
  #tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.14.tar.gz"
  sha1 "7e7f721b033f9d4b706c036d439af3f3bb0c5efe"

  head 'https://github.com/bedops/bedops.git'

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "6cc75b37079619bf5db8293b1963308dca814b30e86d914e364e5c702cd0de55" => :yosemite
    sha256 "6e8cccfcb3b4a84fbeace9f63daf691c0dae635afbf0017c1b9dae1961c226a2" => :mavericks
    sha256 "996564dabc7e246a7f66932a019fd0697dfdf2d48ae8b12e269b2ed4296b4f6d" => :mountain_lion
  end

  env :std

  fails_with :gcc do
    build 5666
    cause 'BEDOPS toolkit requires a C++11 compliant compiler'
  end

  def install
    ENV.O3
    ENV.delete('CFLAGS')
    ENV.delete('CXXFLAGS')
    system 'make'
    system 'make', 'install'
    bin.install Dir['bin/*']
    doc.install %w[LICENSE README.md]
  end

  test do
    system "#{bin}/bedops", '--version'
  end
end
