class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM."
  homepage "http://www.mfem.org"
  url "http://goo.gl/Y9T75B"
  version "3.2"
  sha256 "2938c3deed4ec4f7fd5b5f5cfe656845282e86e2dcd477d292390058b7b94340"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "add411a7b262076c0904a46a84899600e8470d8e85c98b50de3ef1d56cfd4cfd" => :el_capitan
    sha256 "31ed369413510f6b00c8e82dd3cd9032214447bf70ba3a23c646e9ce025688a3" => :yosemite
    sha256 "3534c03d57c732ae05840bb3a29ca8e55e12c2376493698f53b76366f2d447fb" => :mavericks
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

  if OS.mac?
    depends_on "openblas" => :optional
  else
    depends_on "openblas"
  end

  depends_on "suite-sparse" => :optional
  depends_on "netcdf" => :optional
  depends_on "superlu_dist" => :optional

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
      ss_lib += "-lklu -lbtf -lumfpack -lcholmod -lcolamd -lamd -lcamd "
      ss_lib += "-lccolamd -lsuitesparseconfig #{metis_lib} #{lapack_lib}"
      make_args += ["MFEM_USE_SUITESPARSE=YES",
                    "SUITESPARSE_DIR=#{Formula["suite-sparse"].opt_prefix}",
                    "SUITESPARSE_OPT=-I#{Formula["suite-sparse"].opt_include}",
                    "SUITESPARSE_LIB=#{ss_lib}"]
    end

    if build.with?("superlu_dist")
      superlu_lib = "-L#{Formula["superlu_dist"].opt_lib} -lsuperlu_dist"
      make_args += ["MFEM_USE_SUPERLU=YES",
                    "SUPERLU_DIR=#{Formula["superlu_dist"].opt_prefix}",
                    "SUPERLU_OPT=-I#{Formula["superlu_dist"].opt_include}",
                    "SUPERLU_LIB=#{superlu_lib}"]
    end

    if build.with?("netcdf")
      netcdf_lib = "-L#{Formula["netcdf"].opt_lib} -lnetcdf "
      netcdf_lib += "-L#{Formula["hdf5"].opt_lib} -lhdf5_hl -lhdf5 "
      if OS.mac?
        netcdf_lib += "-L/usr/lib -lz"
      else
        netcdf_lib += "-L#{Formula["zlib"].opt_lib} -lz"
      end
      zlib_dir = OS.mac? ? "/usr" : Formula["zlib"].opt_prefix.to_s
      make_args += ["MFEM_USE_NETCDF=YES",
                    "NETCDF_DIR=#{Formula["netcdf"].opt_prefix}",
                    "HDF5_DIR=#{Formula["hdf5"].opt_prefix}",
                    "ZLIB_DIR=#{zlib_dir}",
                    "NETCDF_OPT=-I#{Formula["netcdf"].opt_include}",
                    "NETCDF_LIB=#{netcdf_lib}"]
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
