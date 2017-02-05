class Silo < Formula
  desc "LLNL mesh and field Silo I/O library. Allows creating databases for VisIt."
  homepage "https://wci.llnl.gov/simulation/computer-codes/silo"
  url "https://wci.llnl.gov/content/assets/docs/simulation/computer-codes/silo/silo-4.10.2/silo-4.10.2-bsd.tar.gz"
  sha256 "4b901dfc1eb4656e83419a6fde15a2f6c6a31df84edfad7f1dc296e01b20140e"
  revision 2

  bottle do
    sha256 "52251fed40a781df40d04b7efc5918f43deb09af9f76e818a041a3ee3cc2b4c9" => :sierra
    sha256 "f3025dab277f25067a8f26e597a5fe69784c691be9e5f18ab31125cd761d2058" => :el_capitan
    sha256 "f79c0a4b060e3b03be87a8085e733ef2827f3cf76a43f9804ea6ec39d804cfc2" => :yosemite
  end

  option "with-static", "Build as static instead of dynamic library"
  option "without-lite-headers", "Do not install PDB lite headers"

  depends_on :x11 => :optional
  depends_on :fortran
  depends_on "readline"
  depends_on "hdf5" => :recommended

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-optimization"
    args << "--with-zlib"
    args << "--enable-install-lite-headers" if build.with? "lite-headers"
    args << "--enable-shared" if build.without? "static"
    args << "--enable-x" if build.with? "x11"
    args << "--with-hdf5=#{Formula["hdf5"].opt_prefix}" if build.with? "hdf5"

    ENV.append "LDFLAGS", "-L#{Formula["readline"].opt_lib} -lreadline"
    system "./configure", *args
    system "make", "install"
    if build.with? "hdf5"
      rm lib/"libsiloh5.settings"
    else
      rm lib/"libsilo.settings"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
        #include <silo.h>

        int main(void)
        {
            DBfile *silodb;
            silodb = DBCreate("test.silo", DB_CLOBBER, DB_LOCAL, NULL, DB_PDB);
            if (!silodb)
                return 1;

            DBClose(silodb);
            return 0;
        }
        EOS
    test_args = ["test.c", "-I#{opt_include}", "-L#{opt_lib}", "-o", "test"]
    if build.with? "hdf5"
      test_args << "-lsiloh5"
      test_args << "-L#{Formula["hdf5"].opt_lib}"
      test_args << "-lhdf5"
    else
      test_args << "-lsilo"
    end
    test_args << "-lm"
    system ENV.cc, *test_args
    system "./test"
  end
end
