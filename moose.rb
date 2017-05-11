class Moose < Formula
  desc "Multiscale Object Oriented Simulation Environment"
  homepage "http://moose.ncbs.res.in"
  url "https://github.com/BhallaLab/moose-core/archive/3.1.1.tar.gz"
  sha256 "d86710e77973b020a6889526418128893b4173cbc665df693dfdc1e27594b90e"
  revision 1
  head "https://github.com/BhallaLab/moose-core.git"

  bottle do
    cellar :any
    sha256 "6077f886560480c956270f855cf9576a3e8261c5f2ea064117c3483f74a84462" => :sierra
    sha256 "a637de34ce0b92f16afc120ecb2e0e4aff8f8a2e6a2ada5521ee01cf7ccdca9e" => :el_capitan
    sha256 "1bb0712ef178577a3c44190be8f21f894cddc66ce03f742d768e44371425dce7" => :yosemite
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
    (buildpath/"VERSION").write("#{version}\n")
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
      system "cmake", "..", "-DPYTHON_EXECUTABLE:FILEPATH=#{which("python")}", *args
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
