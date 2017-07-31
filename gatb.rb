class Gatb < Formula
  desc "Genome Analysis Toolbox for de Bruijn graphs"
  homepage "https://gatb.inria.fr/"
  # doi "10.1093/bioinformatics/btu406"
  # tag "bioinformatics"

  url "http://gatb-core.gforge.inria.fr/versions/src/gatb-core-1.1.0-Source.tar.gz"
  sha256 "d75fe178c97d85f11e3cf51bfb8ae4a6b9f864587f3762a7ca608abe48ed4a03"

  bottle do
    sha256 "9140d235a079f1159f693405494ea29bea39bd2d5ec039933da375899e49a825" => :el_capitan
    sha256 "8381c85fa3d43831ee3991ab509211e7297b43c8f4f4df28166d71ef8d313730" => :yosemite
    sha256 "6d8e8013b68a2bda35f0044c5272d94c99c85bae0199478690a3e13363997029" => :mavericks
    sha256 "fd2fac2613ee332def1e987c5a104c730e062afac99929aab4aa43d58f59228e" => :x86_64_linux
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
