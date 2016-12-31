class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.03.tar.gz"
  version "10.3.0"
  sha256 "7da84f3d7ddea31db2130c4769a474a7bd387839cc9c04d3081408a7004cb73b"

  bottle do
    cellar :any
    sha256 "e2527a24c5e676d2aed83e0d22b11d42d480faefacd664413f953b202b717632" => :sierra
    sha256 "9224f1386741784204d3e171b9d4f25500bd54c5f95717884cdc0501832871d8" => :el_capitan
    sha256 "115fd866c35c07e12e3cf5f03333c42c37646c9122caa3c4e94b152756ac2bc4" => :yosemite
    sha256 "1d6445145533902bf759553f9485fff19c27d66a58812e09e5ef8277a2a4ebbd" => :x86_64_linux
  end

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-usolids", "Use USolids (experimental)"
  option "without-multithreaded", "Build without multithreading support"

  depends_on "cmake" => :run
  depends_on :x11
  depends_on "qt5" => :optional
  depends_on "xerces-c" if build.with? "gdml"

  resource "G4NEUTRONHPDATA" do
    url "http://geant4.cern.ch/support/source/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4LEDATA" do
    url "http://geant4.cern.ch/support/source/G4EMLOW.6.50.tar.gz"
    sha256 "c97be73fece5fb4f73c43e11c146b43f651c6991edd0edf8619c9452f8ab1236"
  end

  resource "G4LEVELGAMMADATA" do
    url "http://geant4.cern.ch/support/source/G4PhotonEvaporation.4.3.tar.gz"
    sha256 "1a8d0b4ee60dfbbca38fb313e70508dde3a2ec0f34af59baedd37cb9ae68427e"
  end

  resource "G4RADIOACTIVEDATA" do
    url "http://geant4.cern.ch/support/source/G4RadioactiveDecay.5.1.tar.gz"
    sha256 "f30ed6efcde0d8554559a30a23cf17881565d50fdb2c30d2c36983434b1bfcc6"
  end

  resource "G4NEUTRONXSDATA" do
    url "http://geant4.cern.ch/support/source/G4NEUTRONXS.1.4.tar.gz"
    sha256 "57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd"
  end

  resource "G4PIIDATA" do
    url "http://geant4.cern.ch/support/source/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4REALSURFACEDATA" do
    url "http://geant4.cern.ch/support/source/RealSurface.1.0.tar.gz"
    sha256 "3e2d2506600d2780ed903f1f2681962e208039329347c58ba1916740679020b1"
  end

  resource "G4SAIDXSDATA" do
    url "http://geant4.cern.ch/support/source/G4SAIDDATA.1.1.tar.gz"
    sha256 "a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f"
  end

  resource "G4ABLADATA" do
    url "http://geant4.cern.ch/support/source/G4ABLA.3.0.tar.gz"
    sha256 "99fd4dcc9b4949778f14ed8364088e45fa4ff3148b3ea36f9f3103241d277014"
  end

  resource "G4ENSDFSTATEDATA" do
    url "http://geant4.cern.ch/support/source/G4ENSDFSTATE.2.1.tar.gz"
    sha256 "933e7f99b1c70f24694d12d517dfca36d82f4e95b084c15d86756ace2a2790d9"
  end

  def install
    (share/"Geant4-#{version}/data/G4NDL4.5").install resource("G4NEUTRONHPDATA")
    (share/"Geant4-#{version}/data/G4EMLOW6.50").install resource("G4LEDATA")
    (share/"Geant4-#{version}/data/PhotonEvaporation4.3").install resource("G4LEVELGAMMADATA")
    (share/"Geant4-#{version}/data/RadioactiveDecay5.1").install resource("G4RADIOACTIVEDATA")
    (share/"Geant4-#{version}/data/G4NEUTRONXS1.4").install resource("G4NEUTRONXSDATA")
    (share/"Geant4-#{version}/data/G4PII1.3").install resource("G4PIIDATA")
    (share/"Geant4-#{version}/data/RealSurface1.0").install resource("G4REALSURFACEDATA")
    (share/"Geant4-#{version}/data/G4SAIDDATA1.1").install resource("G4SAIDXSDATA")
    (share/"Geant4-#{version}/data/G4ABLA3.0").install resource("G4ABLADATA")
    (share/"Geant4-#{version}/data/G4ENSDFSTATE2.1").install resource("G4ENSDFSTATEDATA")

    mkdir "geant-build" do
      args = %w[
        ../
        -DGEANT4_USE_OPENGL_X11=ON
        -DGEANT4_USE_RAYTRACER_X11=ON
        -DGEANT4_BUILD_EXAMPLE=ON
      ]

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
