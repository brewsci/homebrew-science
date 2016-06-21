class Gatb < Formula
  desc "Genome Analysis Toolbox for de Bruijn graphs"
  homepage "https://gatb.inria.fr/"
  # doi "10.1093/bioinformatics/btu406"
  # tag "bioinformatics"

  url "http://gatb-core.gforge.inria.fr/versions/src/gatb-core-1.1.0-Source.tar.gz"
  version "1.1.0"
  sha256 "d75fe178c97d85f11e3cf51bfb8ae4a6b9f864587f3762a7ca608abe48ed4a03"

  bottle do
    sha256 "2d34597f4d793a15bad4d280df11cec2a9a818cf87d20f600107e00cb6ce573f" => :yosemite
    sha256 "a9a8ae6f10923cc1ff228dfa8b12b16ae854a77a0433c0bb5421f749d25a6db8" => :mavericks
    sha256 "04c59f4e814f1348a768189079f18021b246857a8e9cc5d9da316c15a3874f2e" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      # Fix the error: 'hdf5/hdf5.h' file not found
      args = std_cmake_args
      args.delete "-DCMAKE_BUILD_TYPE=Release"
      system "cmake", "..", *args
      system "make", "install"

      # Remove conflicts with hdf5
      rm bin/"h5dump"
      rm lib/"libhdf5.a"
      rm_r include/"hdf5"
    end
  end

  test do
    assert_match "graph", shell_output("#{bin}/dbginfo", 1)
  end
end
