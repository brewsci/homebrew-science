require "formula"

class Idba < Formula
  homepage "http://i.cs.hku.hk/~alse/hkubrg/projects/idba/"
  #doi "10.1093/bioinformatics/bts174"
  #tag "bioinformatics"

  url "https://hku-idba.googlecode.com/files/idba-1.1.1.tar.gz"
  sha1 "6dcbd35281c2bc46b8df550a369952a9138e92a2"

  bottle do
    cellar :any
    sha256 "9ce6a82cee5d4a891f1dfe38a9a6a9d2a409f9fe9d2193c54cce498a53897eef" => :yosemite
    sha256 "066ff8986d811ee9190db54c6fbfb77fde054ef0c096800438fa2338a4badec6" => :mavericks
    sha256 "10bf4be36d3797c48f58580078ee2d197227cdb297f5b2ba826590fd4ba92983" => :mountain_lion
  end

  fails_with :clang do
    build 600
    cause "Requires OpenMP"
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make"
    bin.install Dir["bin/idba*"].select { |x| File.executable? x }
    libexec.install Dir["bin/*"].select { |x| File.executable? x }
    doc.install %w[AUTHORS ChangeLog NEWS README]
  end

  test do
    system "#{bin}/idba_ud 2>&1 |grep IDBA"
  end
end
