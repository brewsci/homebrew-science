class Moose < Formula
  desc "Multiscale Object Oriented Simulation Environment"
  homepage "http://moose.ncbs.res.in"
  url "https://github.com/BhallaLab/moose-core/archive/3.1.0.tar.gz"
  sha256 "3914535e9554473ee629289de1281aab95f85cc27b6602c26f01a46f6ccec968"
  revision 2
  head "https://github.com/BhallaLab/moose-core.git"

  bottle do
    cellar :any
    sha256 "3e0760f180d56f0bf9f60b35ca33c27e912da88484a3ac2a21375dc22d6f603e" => :sierra
    sha256 "2a88097a951e0d23ff0b26cd527bfcd85323bb75c3eb03b18966805c67ac1a5b" => :el_capitan
    sha256 "a1e5033f49aaa7031a4daea53c71251276dbde71d06f593866a18444469c008d" => :yosemite
  end

  option "with-sbml", "Enable sbml support"

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "hdf5"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "numpy"

  if build.with?("sbml")
    resource "sbml" do
      url "https://downloads.sourceforge.net/project/sbml/libsbml/5.9.0/stable/libSBML-5.9.0-core-src.tar.gz"
      sha256 "8991e4a6876721999433495b747b790af7981ae57b485e6c92b7fbb105bd7e96"
    end
  end

  def install
    # FindHDF5.cmake needs a little help
    ENV.prepend "LDFLAGS", "-lhdf5 -lhdf5_hl"

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
