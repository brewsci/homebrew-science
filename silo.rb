class Silo < Formula
  desc "LLNL Silo library. Allows to create databases for VisIt."
  homepage "https://wci.llnl.gov/simulation/computer-codes/silo"
  url "https://wci.llnl.gov/content/assets/docs/simulation/computer-codes/silo/silo-4.10.2/silo-4.10.2-bsd.tar.gz"
  sha256 "4b901dfc1eb4656e83419a6fde15a2f6c6a31df84edfad7f1dc296e01b20140e"

  bottle do
    sha256 "121f4802d1e18e049f50360b9d6222867028320cea21a33ead806db3d55e1a3d" => :sierra
    sha256 "cc3fd7ae2ebf5f32a9d0d49f037405dc01e51e094a5c26e20c46a5dc9f811f80" => :el_capitan
    sha256 "61153eafb69d477e1270b07a951f402192d38c13759cd064801ad0d7ccd60e02" => :yosemite
  end

  depends_on :x11 => :optional
  depends_on :fortran
  depends_on "readline"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-optimization"
    args << "--enable-x" if build.with? "x11"

    ENV.append "LDFLAGS", "-L#{Formula["readline"].opt_lib} -lreadline"
    system "./configure", *args
    system "make", "install"
    rm lib/"libsilo.settings"
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
    system ENV.cc, "test.c", "-I#{opt_include}", "-L#{opt_lib}", "-lsilo", "-o", "test"
    system "./test"
  end
end
