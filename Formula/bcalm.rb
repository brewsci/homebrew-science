class Bcalm < Formula
  desc "de Bruijn graph compaction in low memory"
  homepage "https://github.com/GATB/bcalm"
  # doi "10.1093/bioinformatics/btw279"
  # tag "bioinformatics"

  url "https://github.com/GATB/bcalm.git",
      :tag => "v2.2.0",
      :revision => "c8ac60252fa0b2abf511f7363cff7c4342dac2ee"

  head "https://github.com/GATB/bcalm.git"

  bottle do
    sha256 "149330142a81e5f443e69b3b86c86e5921ff86e5b7bcb42e4cae9ff012a94821" => :high_sierra
    sha256 "0dc6bfe043184d2103b59e5b1062df023af47326009ef48c2d91ce9bf38bc6f3" => :sierra
    sha256 "e925ce5d727906d94652f8104740677350778d8266a65c2a46d2c35a2fcce429" => :el_capitan
    sha256 "b0172557bb0a7b33ef3592ae9d2af11f589f3d4e25361301f0493d1170f71399" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "bcalm"
    end
  end

  test do
    system bin/"bcalm"
  end
end
