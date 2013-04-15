require 'formula'

class SuiteSparse < Formula
  homepage 'http://www.cise.ufl.edu/research/sparse/SuiteSparse'
  url 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-4.2.0.tar.gz'
  sha1 'd99f88afc69ee4d073541ff7a68bc4f26bda5853'

  depends_on "tbb" => :recommended
  depends_on "openblas" => :optional
  # Metis is optional for now because of
  # cholmod_metis.c:164:21: error: use of undeclared identifier 'idxtype'
  depends_on "metis4" => :optional # metis 5.x is not yet supported by suite-sparse

  def install
    # SuiteSparse doesn't like to build in parallel
    ENV.j1

    # Switch to the Mac base config, per SuiteSparse README.txt
    system "mv SuiteSparse_config/SuiteSparse_config.mk SuiteSparse_config/SuiteSparse_config_orig.mk"
    system "mv SuiteSparse_config/SuiteSparse_config_Mac.mk SuiteSparse_config/SuiteSparse_config.mk"
    
    inreplace "SuiteSparse_config/SuiteSparse_config.mk" do |s|
      if build.include? 'with-openblas'
        s.change_make_var! "BLAS", "-lopenblas"
        s.change_make_var! "LAPACK", "$(BLAS)"
      end

      unless build.include? "without-tbb"
        s.change_make_var! "SPQR_CONFIG", "-DHAVE_TBB"
        s.change_make_var! "TBB", "-ltbb"
      end

      if build.include? "with-metis4"
        s.remove_make_var! "METIS_PATH"
        s.change_make_var! "METIS", Formula.factory("metis4").lib + "libmetis.a"
      end

      s.change_make_var! "INSTALL_LIB", lib
      s.change_make_var! "INSTALL_INCLUDE", include
    end

    system "make library"

    lib.mkpath
    include.mkpath
    system "make install"
  end
end
