require 'formula'

class Trnascan < Formula
  homepage 'http://selab.janelia.org/tRNAscan-SE/'
  url 'http://selab.janelia.org/software/tRNAscan-SE/tRNAscan-SE.tar.Z'
  sha1 'fd2db5b1bb059dfdcf0fced1c865909da601d71f'
  version '1.23'

  def install
    make_args = ["CFLAGS=-D_POSIX_C_SOURCE=1", "LIBDIR=#{libexec}", "BINDIR=#{bin}"]
    system "make", "all", *make_args

    bin.install %w[coves-SE covels-SE eufindtRNA trnascan-1.4]
    bin.install "tRNAscan-SE.src".sub(/\.src/, "")

    (share / name).install Dir.glob("Demo/*.fa")
    (share / name).install "testrun.ref"

    libexec.install Dir.glob("gcode.*")
    libexec.install Dir.glob("*.cm")
    libexec.install Dir.glob("*signal")

    File.rename("tRNAscan-SE.man", "tRNAscan-SE.1")
    man1.install "tRNAscan-SE.1"
  end

  test do
    system "tRNAscan-SE -d -y -o test.out #{share}/#{name}/F22B7.fa"
    if FileTest.exists? "test.out"
      %x(diff test.out #{share}/#{name}/testrun.ref).empty? ? true : false
    else
      false
    end
  end
end
