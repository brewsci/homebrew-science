class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  #doi "10.1093/bioinformatics/bts277"
  #tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.3.tar.gz"
  sha1 "d9304c63f53cb948e59fe04b0ea96c3ea4da1da3"

  head 'https://github.com/bedops/bedops.git'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "a11fa843cf57a66cc8df65c9258589678a162790" => :yosemite
    sha1 "aa9862870a8b866d3fa4cea6ec50d16107ecbe83" => :mavericks
    sha1 "edd6cbf28e1c1f9f4db6fcec8ce373bfc1e12554" => :mountain_lion
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
