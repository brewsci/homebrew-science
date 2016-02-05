class Geant < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.02.tar.gz"
  sha256 "633ca2df88b03ba818c7eb09ba21d0667a94e342f7d6d6ff3c695d83583b8aa3"

  bottle do
    cellar :any
    sha256 "1cd7b1d34f8ba1bc49712994a812554de5eb63cbd68cff2df092ebf576e9dd62" => :el_capitan
    sha256 "e2d63ca0fc0fd82f33f5a1fcced486df68b7a7d80aeb092c2e28b86821d29eea" => :yosemite
    sha256 "cc53e4c82f06681bb3cdac8e30fe7169cca7c6c1158727a4bdf45d17dcf7a6c9" => :mavericks
  end

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-notimeout", "Set notimeout in installing data"
  option "with-usolids", "Use USolids (experimental)"
  option "with-multithreaded", "Build with multithreading enabled"

  depends_on "cmake" => :build
  depends_on :x11
  depends_on "qt" => :optional
  depends_on "xerces-c" if build.with? "gdml"

  def install
    mkdir "geant-build" do
      args = %W[
        ../
        -DGEANT4_INSTALL_DATA=ON
        -DGEANT4_USE_OPENGL_X11=ON
        -DGEANT4_USE_RAYTRACER_X11=ON
        -DGEANT4_BUILD_EXAMPLE=ON
      ]

      args << "-DGEANT4_INSTALL_DATA_TIMEOUT=86400" if build.with? "notimeout"
      args << "-DGEANT4_USE_QT=ON" if build.with? "qt"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
      args << "-DGEANT4_USE_USOLIDS=ON" if build.with? "usolids"
      args << "-DGEANT4_BUILD_MULTITHREADED=ON" if build.with? "multithreaded"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end
end
