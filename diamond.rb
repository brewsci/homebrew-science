class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.4.tar.gz"
  sha256 "74eaa16ff95051f11d4c30cf425c35e577093843f105f10909b22d7610fccf32"

  bottle do
    cellar :any_skip_relocation
    sha256 "edc27a26b9e8911257a9eca935b80318214fb172478b3c6f751d06e5b89a24f6" => :sierra
    sha256 "d52306056c2a379f6fecc757a1241907faf04a4bbc4a8a6ceb73872b393a2631" => :el_capitan
    sha256 "09727954be3dd2bfe20dbb44495dd1b476bd1e072becd3f50aeb9281a6e81635" => :yosemite
    sha256 "805b6e105a15d2b41efc1e191ffe7aecca380d26aa53e2277f76e47431061428" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
