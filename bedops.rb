class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  #doi "10.1093/bioinformatics/bts277"
  #tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.9.tar.gz"
  sha1 "7d3bb19d15fc29fa77b82362074d896a5a5b021e"

  head 'https://github.com/bedops/bedops.git'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "b047b7d458bf751fb46045d6fa8e3d1a52a91eef" => :yosemite
    sha1 "c6f7d47e30777f7707961e59f5baa8caafcbcf8f" => :mavericks
    sha1 "2f9c45d2b58c6a1522672269e403b89f35903e56" => :mountain_lion
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
