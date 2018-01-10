class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.03.p03.tar.gz"
  version "10.3.3"
  sha256 "a164f49c038859ab675eec474d08c9d02be8c4be9c0c2d3aa8e69adf89e1e138"

  bottle do
    cellar :any
    sha256 "c772638082c68d6610ee73325e4cea2559a000e0b0f954a55be26154019bf105" => :high_sierra
    sha256 "ec5643125522f34ebfce1125a838c34519b9bf356c63870d5c6c328a64e63b63" => :sierra
    sha256 "b9b5bafa9f756f11a2a5113b8f3e058af2f07c1c21010ca7fe0cf7271cdd4016" => :el_capitan
    sha256 "ab2c884c84ace2445f714ef1a23482c4d902b6cae3ff5cb63befe37601e5a41e" => :x86_64_linux
  end

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-usolids", "Use USolids (experimental)"
  option "without-multithreaded", "Build without multithreading support"

  depends_on "cmake" => :run
  depends_on :x11
  depends_on "qt" => :optional
  depends_on "xerces-c" if build.with? "gdml"
  depends_on "linuxbrew/xorg/glu" unless OS.mac?

  resource "G4NDL" do
    url "http://geant4.cern.ch/support/source/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4EMLOW" do
    url "http://geant4.cern.ch/support/source/G4EMLOW.6.50.tar.gz"
    sha256 "c97be73fece5fb4f73c43e11c146b43f651c6991edd0edf8619c9452f8ab1236"
  end

  resource "G4PhotonEvaporation" do
    url "http://geant4.cern.ch/support/source/G4PhotonEvaporation.4.3.2.tar.gz"
    sha256 "d4641a6fe1c645ab2a7ecee09c34e5ea584fb10d63d2838248bfc487d34207c7"
  end

  resource "G4RadioactiveDecay" do
    url "http://geant4.cern.ch/support/source/G4RadioactiveDecay.5.1.1.tar.gz"
    sha256 "f7a9a0cc998f0d946359f2cb18d30dff1eabb7f3c578891111fc3641833870ae"
  end

  resource "G4NEUTRONXS" do
    url "http://geant4.cern.ch/support/source/G4NEUTRONXS.1.4.tar.gz"
    sha256 "57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd"
  end

  resource "G4PII" do
    url "http://geant4.cern.ch/support/source/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "RealSurface" do
    url "http://geant4.cern.ch/support/source/RealSurface.1.0.tar.gz"
    sha256 "3e2d2506600d2780ed903f1f2681962e208039329347c58ba1916740679020b1"
  end

  resource "G4SAIDDATA" do
    url "http://geant4.cern.ch/support/source/G4SAIDDATA.1.1.tar.gz"
    sha256 "a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f"
  end

  resource "G4ABLA" do
    url "http://geant4.cern.ch/support/source/G4ABLA.3.0.tar.gz"
    sha256 "99fd4dcc9b4949778f14ed8364088e45fa4ff3148b3ea36f9f3103241d277014"
  end

  resource "G4ENSDFSTATE" do
    url "http://geant4.cern.ch/support/source/G4ENSDFSTATE.2.1.tar.gz"
    sha256 "933e7f99b1c70f24694d12d517dfca36d82f4e95b084c15d86756ace2a2790d9"
  end

  def install
    mkdir "geant-build" do
      args = %w[
        ../
        -DGEANT4_USE_OPENGL_X11=ON
        -DGEANT4_USE_RAYTRACER_X11=ON
        -DGEANT4_BUILD_EXAMPLE=ON
      ]

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

  def post_install
    resources.each do |r|
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
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
