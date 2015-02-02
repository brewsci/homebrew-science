class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  #doi "10.1093/bioinformatics/bts277"
  #tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.6.tar.gz"
  sha1 "c7bb6e7308f43a05d6391da08a5548c9e0c1662e"

  head 'https://github.com/bedops/bedops.git'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "e133b4d25c0363f25d6102cec527984b9091e3c3" => :yosemite
    sha1 "a8ed7272e566c05d32957e1f1c0e377a77c52f94" => :mavericks
    sha1 "4e1bdb03daca349189af09beeb28a47ca84c1e1a" => :mountain_lion
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
