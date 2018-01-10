class Galsim < Formula
  desc "The modular galaxy image simulation toolkit"
  homepage "https://github.com/GalSim-developers/GalSim"
  url "https://github.com/GalSim-developers/GalSim/archive/v1.3.0.tar.gz"
  sha256 "4afd3284adfd12845b045ea3c8e293b63057c7da57872bc9eecd005cf0a763c0"
  revision 2
  head "https://github.com/GalSim-developers/GalSim.git"

  bottle :disable, "needs to be rebuilt with latest boost"

  option "with-openmp", "Enable OpenMP multithreading"
  option "without-test", "Skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "scons" => :build
  depends_on "fftw"
  depends_on "boost"
  depends_on "boost-python"
  depends_on "tmv-cpp"

  # FITS support should come from astropy.io.fits (PyFITS has been deprecated)
  depends_on "astropy" => :python
  depends_on "numpy" => :python
  depends_on "nose" => :python if build.with? "test"

  needs :openmp if build.with? "openmp"

  def pyver
    IO.popen("python -c 'import sys; print sys.version[:3]'").read.strip
  end

  def install
    args = ["BOOST_DIR=#{Formula["boost"].opt_prefix}",
            "FFTW_DIR=#{Formula["fftw"].opt_prefix}",
            "TMV_DIR=#{Formula["tmv-cpp"].opt_prefix}",
            "TMV_LINK=#{Formula["tmv-cpp"].opt_share}/tmv/tmv-link",
            "EXTRA_LIB_PATH=#{Formula["boost-python"].opt_lib}"]
    args << "WITH_OPENMP=true" if build.with? "openmp"
    scons *args
    scons "tests"
    scons "install", "PREFIX=#{prefix}", "PYPREFIX=#{lib}/python#{pyver}/site-packages"
    pkgshare.install "examples"
  end

  def caveats
    homebrew_site_packages = Language::Python.homebrew_site_packages
    user_site_packages = Language::Python.user_site_packages "python"
    s = <<-EOS.undent
      If you use the Apple-provided Python instead of one from Homebrew, you
      may want to add all Homebrew python packages to the default paths
      by running:

        mkdir -p #{user_site_packages}
        echo 'import sys; sys.path.insert(1, "#{homebrew_site_packages}")' >> \\
            #{user_site_packages}/homebrew.pth
    EOS
    s
  end

  test do
    ENV.prepend_create_path "PYTHONPATH", (opt_lib/"python#{pyver}")
    cp_r opt_pkgshare/"examples", testpath
    ln_s opt_pkgshare/"acs_I_unrot_sci_20_cf.fits", testpath/"examples/data/"
    ln_s opt_pkgshare/"vega.txt", testpath/"examples/data/"
    cd testpath/"examples" do
      Dir["demo*.py"].each do |demo|
        system "python", demo
      end
    end
  end
end
