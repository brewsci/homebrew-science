class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.02.p02.tar.gz"
  version "10.2.2"
  sha256 "702fb0f7a78d4bdf1e3f14508de26e4db5e2df6a21a8066a92b7e6ce21f4eb2d"

  bottle do
    cellar :any
    sha256 "52fd5a0349ab95bdf8845e4004bd9f9dc62297398d5dac0ffef91035543d58a2" => :el_capitan
    sha256 "0436df6b3df27f97cddf7af4b1e624749160f79081f457aee6be135d50c84543" => :yosemite
    sha256 "dd16a3e8db47d77e4a1500a3a6f53dae60d166bf2705afff788c5b62b48252df" => :mavericks
  end

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-notimeout", "Set notimeout in installing data"
  option "with-usolids", "Use USolids (experimental)"
  option "without-multithreaded", "Build without multithreading support"

  depends_on "cmake" => :run
  depends_on :x11
  depends_on "qt5" => :optional
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
      args << "-DGEANT4_USE_QT=ON" if build.with? "qt5"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
      args << "-DGEANT4_USE_USOLIDS=ON" if build.with? "usolids"
      args << "-DGEANT4_BUILD_MULTITHREADED=ON" if build.with? "multithreaded"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<-EOS.undent
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    system "/bin/bash", "test.sh"
  end
end
