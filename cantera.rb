require 'formula'

class Cantera < Formula
  homepage 'http://github.com/Cantera/cantera'
  head 'https://github.com/cantera/cantera.git', :branch => 'master'

  stable do
    url "https://github.com/Cantera/cantera/releases/download/v2.2.0/cantera-2.2.0.tar.gz"
    sha1 "b6e4226f27075ffb8686a24661be79d6d3ff9888"
  end

  option "with-matlab=", "Path to Matlab root directory"
  option "without-check", "Disable build-time checking (not recommended)"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "scons" => :build
  depends_on "numpy" => :python
  depends_on "cython" => :python
  depends_on "sundials" => :recommended
  depends_on :python3 => :optional
  depends_on "graphviz" => :optional

  def install
    # Make sure to use Homebrew Python to do CTI to CTML conversions
    inreplace "src/base/ct2ctml.cpp", 's = "python";', 's = "/usr/local/bin/python";'

    build_args = ["prefix=#{prefix}",
                  "python_package=full",
                  "CC=#{ENV.cc}",
                  "CXX=#{ENV.cxx}",
                  "f90_interface=n"]

    matlab_path = ARGV.value("with-matlab")
    build_args << "matlab_path=" + matlab_path if matlab_path
    build_args << "python3_package=y" if build.with? :python3

    scons "build", *build_args
    scons "test" if build.with? "check"
    scons "install"
    prefix.install Dir["License.*"]
  end

  test do
    # Run those portions of the test suite that do not depend of data
    # that's only available in the source tree.
    system("python", "-m", "unittest", "-v",
           "cantera.test.test_thermo",
           "cantera.test.test_kinetics",
           "cantera.test.test_transport",
           "cantera.test.test_purefluid",
           "cantera.test.test_mixture")
  end

  def caveats; <<-EOS.undent
    The license, demos, tutorials, data, etc. can be found in:
      #{opt_prefix}

    Try the following in python to find the equilibrium composition of a
    stoichiometric methane/air mixture at 1000 K and 1 atm:
    >>> import cantera as ct
    >>> g = ct.Solution('gri30.cti')
    >>> g.TPX = 1000, ct.one_atm, 'CH4:1, O2:2, N2:8'
    >>> g.equilibrate('TP')
    >>> g()
    EOS
  end
end
