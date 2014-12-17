require 'formula'

class Geant < Formula
  homepage 'http://geant4.cern.ch'
  url 'http://geant4.cern.ch/support/source/geant4.10.01.tar.gz'
  sha1 'd888b992b789a0d0e0a1a13debc9a51dae5e3743'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "4cbef3a10978ba3cbbd869415359291369cb4219" => :yosemite
    sha1 "0024b1c66a2a725f051d040212549ab040535fae" => :mavericks
    sha1 "b3f7a2bff728e0f54b6186ef92ce6837253c3d45" => :mountain_lion
  end

  option 'with-g3tog4', 'Use G3toG4 Library'
  option 'with-gdml', 'Use GDML'
  option 'with-notimeout', 'Set notimeout in installing data'

  depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'clhep'
  depends_on 'qt' => :optional
  depends_on 'xerces-c' if build.with? 'gdml'

  def install
    mkdir 'geant-build' do
      args = %W[
               ../
               -DGEANT4_INSTALL_DATA=ON
               -DGEANT4_USE_OPENGL_X11=ON
               -DGEANT4_USE_RAYTRACER_X11=ON
               -DGEANT4_BUILD_EXAMPLE=ON
               -DGEANT4_USE_SYSTEM_CLHEP=ON
               ]

      args << '-DGEANT4_INSTALL_DATA_TIMEOUT=86400' if build.with? 'notimeout'
      args << '-DGEANT4_USE_QT=ON' if build.with? 'qt'
      args << '-DGEANT4_USE_G3TOG4=ON' if build.with? 'g3tog4'
      args << '-DGEANT4_USE_GDML=ON' if build.with? 'gdml'
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make install"
    end
  end
end
