class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM."
  homepage "http://www.mfem.org"
  url "http://goo.gl/Y9T75B"
  version "3.2"
  sha256 "2938c3deed4ec4f7fd5b5f5cfe656845282e86e2dcd477d292390058b7b94340"

  bottle do
    cellar :any_skip_relocation
    sha256 "2febc72f32cd5d4ebe933d61a9d485c9a9754bc339d15458ad25fed24b4d02d4" => :el_capitan
    sha256 "1cbabf97c2ec405d101a37de690ac4e2651f3735c1d8bccf02eda84b71578c7f" => :yosemite
    sha256 "711d04ccd613bc6754c6cb45d4074e0740a0c6f89c1f1d630a1c177243abcc73" => :mavericks
  end

  option "with-mpi", "Build with mpi support (implies --with-hypre --with-metis)"
  option "with-suite-sparse", "Build with suite-sparse support (implies --with-metis)"

  depends_on :mpi => [:cxx, :optional]
  if build.with?("mpi")
    depends_on "metis"
    depends_on "hypre" => "with-mpi"
  else
    depends_on "hypre" => :optional
    depends_on "metis" => :optional
  end

  depends_on "suite-sparse" => :optional
  depends_on "openblas" => :optional

  def install
    make_args = ["PREFIX=#{prefix}"]

    if build.with?("openblas")
      lapack_lib = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      lapack_lib = "-llapack -lblas"
    end
    make_args += ["MFEM_USE_LAPACK=YES", "LAPACK_LIB=#{lapack_lib}"]

    if build.with?("hypre") || build.with?("mpi")
      make_args += ["HYPRE_DIR=#{Formula["hypre"].opt_prefix}",
                    "HYPRE_OPT=-I#{Formula["hypre"].opt_include}",
                    "HYPRE_LIB=-L#{Formula["hypre"].opt_lib} -lHYPRE"]
    end

    if build.with?("metis") || build.with?("mpi") || build.with?("suite-sparse")
      metis_lib = "-L#{Formula["metis"].opt_lib} -lmetis"
      make_args += ["MFEM_USE_METIS_5=YES",
                    "METIS_DIR=#{Formula["metis"].opt_prefix}",
                    "METIS_OPT=-I#{Formula["metis"].opt_include}",
                    "METIS_LIB=#{metis_lib}"]
    end

    make_args += ["MFEM_USE_MPI=YES"] if build.with?("mpi")

    if build.with?("suite-sparse")
      ss_lib = "-L#{Formula["suite-sparse"].opt_lib} "
      ss_lib += "-lumfpack -lcholmod -lcolamd -lamd -lcamd -lccolamd "
      ss_lib += "-lsuitesparseconfig #{metis_lib} #{lapack_lib}"
      make_args += ["MFEM_USE_SUITESPARSE=YES",
                    "SUITESPARSE_DIR=#{Formula["suite-sparse"].opt_prefix}",
                    "SUITESPARSE_OPT=-I#{Formula["suite-sparse"].opt_include}",
                    "SUITESPARSE_LIB=#{ss_lib}"]
    end

    system "make", "config", *make_args
    system "make", "all"
    system "make", "install"

    # Install some examples in pkgshare for users learning the library
    (pkgshare/"examples").mkpath
    (pkgshare/"examples").install Dir["examples/*.cpp"]
    (pkgshare/"examples").install "examples/makefile"
    (pkgshare/"data").mkpath
    (pkgshare/"data").install Dir["data/*.mesh"]
    (pkgshare/"data").install Dir["data/*.vtk"]
    pkgshare.install "config"
  end

  test do
    cp_r "#{Formula["mfem"].opt_pkgshare}/examples", "./"
    cd "examples" do
      cp "#{Formula["mfem"].opt_pkgshare}/data/star.mesh", "./"
      system "make", "all", "MFEM_DIR=#{Formula["mfem"].opt_prefix}", "CONFIG_MK=$(MFEM_DIR)/config.mk", "TEST_MK=#{pkgshare}/config/test.mk"
      args = ["-m", "star.mesh", "--no-visualization"]
      if Tab.for_name("mfem").with? "mpi"
        system "mpirun", "-np", "4", "./ex1p", *args
      else
        system "./ex1", *args
      end
    end
  end
end
