class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM."
  homepage "http://www.mfem.org"
  url "http://goo.gl/xrScXn"
  version "3.1"
  sha256 "841ea5cf58de6fae4de0f553b0e01ebaab9cd9c67fa821e8a715666ecf18fc57"

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
  end

  test do
    cp_r "#{Formula["mfem"].opt_pkgshare}/examples", "./"
    cd "examples" do
      cp "#{Formula["mfem"].opt_pkgshare}/data/star.mesh", "./"
      system "make", "all", "MFEM_DIR=#{Formula["mfem"].opt_prefix}", "CONFIG_MK=$(MFEM_DIR)/config.mk"
      args = ["-m", "star.mesh", "--no-visualization"]
      if Tab.for_name("mfem").with? "mpi"
        system "mpirun", "-np", "4", "./ex1p", *args
      else
        system "./ex1", *args
      end
    end
  end
end
