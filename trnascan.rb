class Trnascan < Formula
  desc "tRNA detection in large-scale genome sequence"
  homepage "http://eddylab.org/software.html"
  # doi "10.1093/nar/25.5.0955"
  # tag "bioinformatics"

  url "http://eddylab.org/software/tRNAscan-SE/tRNAscan-SE.tar.Z"
  version "1.23"
  sha256 "843caf3e258a6293300513ddca7eb7dbbd2225e5baae1e5a7bcafd509f6dd550"

  def install
    make_args = ["CFLAGS=-D_POSIX_C_SOURCE=1", "LIBDIR=#{libexec}", "BINDIR=#{bin}"]
    system "make", "all", *make_args

    bin.install %w[coves-SE covels-SE eufindtRNA trnascan-1.4]
    bin.install "tRNAscan-SE.src".sub(/\.src/, "")

    pkgshare.install Dir.glob("Demo/*.fa")
    pkgshare.install "testrun.ref"

    libexec.install Dir.glob("gcode.*")
    libexec.install Dir.glob("*.cm")
    libexec.install Dir.glob("*signal")

    File.rename("tRNAscan-SE.man", "tRNAscan-SE.1")
    man1.install "tRNAscan-SE.1"
  end

  test do
    system "tRNAscan-SE", "-d", "-y", "-o", "test.out", "#{share}/#{name}/F22B7.fa"
    if FileTest.exists? "test.out"
      `diff test.out #{share}/#{name}/testrun.ref`.empty? ? true : false
    else
      false
    end
  end
end
