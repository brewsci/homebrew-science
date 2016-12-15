class Moose < Formula
  desc "Multiscale Object Oriented Simulation Environment"
  homepage "http://moose.ncbs.res.in"
  url "https://github.com/BhallaLab/moose-core/archive/3.1.0.tar.gz"
  sha256 "3914535e9554473ee629289de1281aab95f85cc27b6602c26f01a46f6ccec968"
  revision 1
  head "https://github.com/BhallaLab/moose-core.git"

  bottle do
    cellar :any
    sha256 "d663c35d239060c80d0828e19d2cc6c8689f3413f06c4350eda6e4b65bcc4bfd" => :sierra
    sha256 "d61d0ce30ae88ec99774fa3a7713d1916f3a4342eb86b2a5dcc22f5d6bffb56d" => :el_capitan
    sha256 "ff36f41cf26b87f6316c8887d31f624865dfca2eb057455c938620626253c828" => :yosemite
  end

  option "with-sbml", "Enable sbml support"

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "hdf5"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "homebrew/python/numpy"

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
