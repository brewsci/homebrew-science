require "formula"

class Idba < Formula
  homepage "http://i.cs.hku.hk/~alse/hkubrg/projects/idba/"
  #doi "10.1093/bioinformatics/bts174"
  url "https://hku-idba.googlecode.com/files/idba-1.1.1.tar.gz"
  sha1 "6dcbd35281c2bc46b8df550a369952a9138e92a2"

  fails_with :clang do
    build 503
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
