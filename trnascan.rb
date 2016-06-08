class Trnascan < Formula
  desc "tRNA detection in large-scale genome sequence"
  homepage "http://eddylab.org/software.html"
  bottle do
    sha256 "e303b3f3feb2f76b0bb5d9f432b7c154c6263b5f8e93fc8bdbba68e7c6cf7fb6" => :el_capitan
    sha256 "dd6e041701336e91373497ad75d0b078fdc5a5875374b4b6c9646c9150bc863c" => :yosemite
    sha256 "2a88b16a0eb5d75885a7c687bb20dd157792c068484ac5a6c8e54c115754a072" => :mavericks
    sha256 "b886e2f0b9267de7201d1a283800cab85015f07c1bbf946ec69b6c4a07625c4d" => :x86_64_linux
  end

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
