class Geant < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.01.tar.gz"
  sha256 "d37400e96423fedfbf8dbe1f49e2ef0367317c3893ad99f28eed06bf97e1feb7"

  bottle do
    sha256 "1bed04e6dd00d665eab93c3625584790f1ad0a4c2a7d8f5fcd226c99833ebc08" => :yosemite
    sha256 "c9ef2ae73e124f50645740808f5174c408c903b844c4a845b551313869a70649" => :mavericks
    sha256 "0c36ec55ff66582e12e1c3e09606d0e4336d82f5a3ee7e956c80d33123569e48" => :mountain_lion
  end

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-notimeout", "Set notimeout in installing data"

  depends_on "cmake" => :build
  depends_on :x11
  depends_on "clhep"
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
        -DGEANT4_USE_SYSTEM_CLHEP=ON
      ]

      args << "-DGEANT4_INSTALL_DATA_TIMEOUT=86400" if build.with? "notimeout"
      args << "-DGEANT4_USE_QT=ON" if build.with? "qt"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end
end
