require "formula"

class Idba < Formula
  homepage "http://i.cs.hku.hk/~alse/hkubrg/projects/idba/"
  #doi "10.1093/bioinformatics/bts174"
  #tag "bioinformatics"

  url "https://hku-idba.googlecode.com/files/idba-1.1.1.tar.gz"
  sha1 "6dcbd35281c2bc46b8df550a369952a9138e92a2"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ba49a3b357e8406997b67350f92ded9005675e25" => :yosemite
    sha1 "0980af9b110108e391d151f8c07cd2be4986e455" => :mavericks
    sha1 "477629a12e2f514b50e4a16873afce2fda40d8bf" => :mountain_lion
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
