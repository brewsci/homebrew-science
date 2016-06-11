class Moose < Formula
  desc "Multiscale Object Oriented Simulation Environment"
  homepage "http://moose.ncbs.res.in"
  url "https://github.com/BhallaLab/moose-core/archive/ghevar_3.0.2-beta.3.tar.gz"
  version "3.0.2"
  sha256 "ad8e7b50874b35190aa5cfdbf0bccaacba241ff19f4d12708f115816cc391b35"

  bottle do
    cellar :any
    sha256 "ce480a1c0d53faa57fe8175784b8c2c10fae4b2fd09f68f376f3ff7d28c9415a" => :el_capitan
    sha256 "58fa41109b47d9c0d9c807105facf8bb3c8fa15f520372e6a8f546b306245da3" => :yosemite
    sha256 "ac9e155cf13f857df151e4004cba0ee3f9ea27a8a4250f5003f34b179b6a41e8" => :mavericks
  end

  option "with-gui", "Enable gui support"
  option "with-sbml", "Enable sbml support"

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "hdf5"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "numpy" => :python

  if build.with?("gui")
    depends_on "pyqt"
    depends_on "matplotlib" => :python

    resource "gui" do
      url "https://github.com/BhallaLab/moose-gui/archive/0.9.0.tar.gz"
      sha256 "d54cfd70759fba0b2f67d5aedfb76967f646e40ff305f7ace8631d3aeabc6459"
    end

    resource "examples" do
      url "https://github.com/BhallaLab/moose-examples/archive/0.9.0.tar.gz"
      sha256 "09c83f6cdc0bab1a6c2eddb919edb33e3809272db3642ea284f6a102b144861d"
    end
  end

  if build.with?("sbml")
    resource "sbml" do
      url "https://downloads.sourceforge.net/project/sbml/libsbml/5.9.0/stable/libSBML-5.9.0-core-src.tar.gz"
      sha256 "8991e4a6876721999433495b747b790af7981ae57b485e6c92b7fbb105bd7e96"
    end
  end

  def install
    args = std_cmake_args
    if build.with?("sbml")
      resource("sbml").stage do
        mkdir "_build" do
          sbml_args = std_cmake_args
          sbml_args << "-DCMAKE_INSTALL_PREFIX=#{buildpath}/_libsbml_static"
          system "cmake", "..", *sbml_args
          system "make", "install"
        end
      end
      ENV["SBML_STATIC_HOME"] = "#{buildpath}/_libsbml_static"
    end

    args << "-DCMAKE_SKIP_RPATH=ON"
    mkdir "_build" do
      system "cmake", "..", *args
      system "make"
    end

    Dir.chdir("_build/python") do
      system "python", *Language::Python.setup_install_args(prefix)
    end

    if build.with?("gui")
      libexec.install resource("gui")
      doc.install resource("examples")

      # A wrapper script to launch moose gui.
      (bin/"moosegui").write <<-EOS.undent
        #!/bin/bash
        BASEDIR="#{libexec}"
        (cd $BASEDIR && python mgui.py)
      EOS
      chmod 0755, bin/"moosegui"
    end
  end

  def caveats; <<-EOS.undent
    You need to install `networkx` and `suds-jurko` using python-pip. Open terminal
    and execute following command:
      $ pip install suds-jurko networkx
    EOS
  end

  test do
    system "python", "-c", "import moose"
  end
end
