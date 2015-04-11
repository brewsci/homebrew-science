class Gatb < Formula
  homepage "https://gatb.inria.fr/"
  # doi "10.1093/bioinformatics/btu406"
  # tag "bioinformatics"

  url "http://gatb-core.gforge.inria.fr/versions/src/gatb-core-1.0.7-Source.tar.gz"
  version "1.0.7"
  sha256 "790803a7a2819566bc89ee24598f9e8c4e114d7d65dc5f87d1d5b8c319f78876"

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
