class Kallisto < Formula
  desc "kallisto: quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # tag "bioinformatics"

  url "https://github.com/pachterlab/kallisto/archive/v0.42.2.tar.gz"
  sha256 "85b89b840dae06c56f59b6ad98b7832ff965df5d259975bc19244584cf918fbf"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "4dfccb2a52d19960f8dbc9f804ac3b822dc5b8b18d7cb07793320115738f4b2f" => :yosemite
    sha256 "b5bc2849f6c9ec3fc1f44b3360db671cd7ba883a5ceae71c31c6c7bc9df15375" => :mavericks
    sha256 "7bfb1b855d4c1ddd5e4aa8e0538766a7c77ba2052c74ef2dcd7af87706a78763" => :mountain_lion
  end

  needs :cxx11
  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/kallisto", 1)
  end
end
