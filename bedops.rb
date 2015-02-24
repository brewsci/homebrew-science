class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  #doi "10.1093/bioinformatics/bts277"
  #tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.11.tar.gz"
  sha1 "da5e7fc76b609b08c3b13c1cb556b89e8d2867db"

  head 'https://github.com/bedops/bedops.git'

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "2b904d983c4935432f5023915ce5fd02dc1b016c" => :yosemite
    sha1 "e5d5a87d513f7b071ae24aa5fb15b7b2a0a31ab7" => :mavericks
    sha1 "fe7fc050d20c08040eb6e6b4878c9390b74a40a5" => :mountain_lion
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
