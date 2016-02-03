class Geant < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.02.tar.gz"
  sha256 "633ca2df88b03ba818c7eb09ba21d0667a94e342f7d6d6ff3c695d83583b8aa3"

  bottle do
    sha256 "1bed04e6dd00d665eab93c3625584790f1ad0a4c2a7d8f5fcd226c99833ebc08" => :yosemite
    sha256 "c9ef2ae73e124f50645740808f5174c408c903b844c4a845b551313869a70649" => :mavericks
    sha256 "0c36ec55ff66582e12e1c3e09606d0e4336d82f5a3ee7e956c80d33123569e48" => :mountain_lion
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
