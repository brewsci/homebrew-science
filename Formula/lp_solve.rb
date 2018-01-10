class NumpyHasHeaders < Requirement
  def numpy_include_dir
    "#{`python -c "import numpy.distutils.misc_util as u; print(u.get_numpy_include_dirs())[0]"`.strip}"
  end

  def satisfied?
    Dir["#{numpy_include_dir}/numpy/*.h"].any?
  end

  def fatal?
    true
  end

  def message; <<-EOS.undent
    lp_solve requires NumPy headers not provided by Apple.
    Install numpy via the Homebrew/python formula:
      `brew tap homebrew/python && brew install numpy`
    EOS
  end
end

class LpSolve < Formula
  homepage "https://sourceforge.net/projects/lpsolve/"
  url "https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.0_source.tar.gz"
  version "5.5.2.0" # automatic version parser spits out "solve" as version
  sha256 "5827a30b143105283f398a09419ea608719a2d7699ecea165a66d521803bcc9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "40e0fb01f795a4e7583802dadd04c8c08fdbe4fe776ea5602a78997fc2575065" => :x86_64_linux
  end

  depends_on :python => :optional
  depends_on NumpyHasHeaders.new if build.with? "python"

  resource "lp_solve_python" do
    # 'http://lpsolve.sourceforge.net/5.5/Python.htm'
    url "https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.0_Python_source.tar.gz"
    sha256 "79683bc262e9da5b2fa7338ba190a9cd10559b9f2dbcb8f3bf07e2a81083ac51"
    version "5.5.2.0"
  end

  # Prefer OS X's fast BLAS implementation (patch stolen from fink-project)
  patch :DATA if OS.mac?

  def install
    # Thanks to superenv, we don't have to care if the ccc.osx build script
    # tells the compiler stupid things. And Xcode-only works like charm.

    # Clang on :snow_leopard does not ignore `-Wno-long-double` and errors out.
    if MacOS.version <= :snow_leopard
      files = %w[configure configure.ac demo/ccc.osx
                 lp_solve/ccc.osx lpsolve55/ccc.osx lpsolve55/cccLUSOL.osx]
      files.each { |f| inreplace f, "-Wno-long-double", "" }
    end

    cd "lpsolve55" do
      if OS.mac?
        system "sh", "ccc.osx", "#", "lpsolve55", "library"
        lib.install Dir["./bin/osx64/*.a"]
        lib.install Dir["./bin/osx64/*.dylib"]
      else
        system "sh", "ccc", "#", "lpsolve55", "library"
        lib.install Dir["./bin/ux64/*.a"]
        lib.install Dir["./bin/ux64/*.so"]
      end
    end

    cd "lp_solve" do
      if OS.mac?
        system "sh", "ccc.osx", "#", "lp_solve", "executable"
        bin.install "./bin/osx64/lp_solve"
      else
        system "sh", "ccc", "#", "lp_solve", "executable"
        bin.install "./bin/ux64/lp_solve"
      end
    end

    # Note, the demo does not build with lpsolve55. Upstream issue.

    include.install Dir["*.h"]
    include.install "shared/commonlib.h", "shared/myblas.h"
    include.install Dir["bfp/bfp_LUSOL/LUSOL/lusol*.h"]

    if build.with? "python"
      # In order to install into the Cellar, the dir must exist and be in the
      # PYTHONPATH.
      temp_site_packages = lib/which_python/"site-packages"
      mkdir_p temp_site_packages
      ENV["PYTHONPATH"] = temp_site_packages
      args = [
        "--force",
        "--verbose",
        "--install-scripts=#{share}/python",
        "--install-lib=#{temp_site_packages}",
        "--record=installed-files.txt",
      ]

      resource("lp_solve_python").stage do
        cd "extra/Python" do
          # On OS X malloc there is <sys/malloc.h> and <malloc/malloc.h>
          inreplace "hash.c", "#include <malloc.h>", "#include <sys/malloc.h>"
          # We know where the lpsolve55 lib is...
          inreplace "setup.py", "LPSOLVE55 = '../../lpsolve55/bin/ux32'", "LPSOLVE55 = '#{lib}'"
          # Correct path to lpsolve's include dir and go the official way to find numpy include_dirs
          inreplace "setup.py",
                    "include_dirs=['../..', NUMPYPATH],",
                    "include_dirs=['#{include}', '#{numpy_include_dir}'],"
          inreplace "setup.py", "(NUMPY, '1')", "('NUMPY', '1')"
          # Even their version number is broken ...
          inreplace "setup.py", 'version = "5.5.0.9",', "version = '#{version}',"

          system "python", "setup.py", "--no-user-cfg", "install", *args

          # Save the examples
          (share/"lp_solve").install Dir["ex*.py"], "lpdemo.py", "Python.htm"
        end
      end
    end
  end

  if build.with? "python"
    def numpy_include_dir
      "#{`python -c "import numpy.distutils.misc_util as u; print(u.get_numpy_include_dirs())[0]"`.strip}"
    end

    def which_python
      "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
    end

    def caveats; <<-EOS.undent
      For non-homebrew Python, you need to amend your PYTHONPATH like so:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

      Python examples and doc are installed to #{HOMEBREW_PREFIX}/share/lp_solve
      EOS
    end
  end

  test do
    input = <<-EOS.undent
      max: 143 x + 60 y;

      120 x + 210 y <= 15000;
      110 x + 30 y <= 4000;
      x + y <= 75;
    EOS
    (testpath/"input.lp").write(input)
    output = `#{bin}/lp_solve -S3 input.lp`
    puts output
    match = output =~ /Value of objective function: 6315\.6250/
    raise if match.nil?
  end
end

__END__
diff --git a/lp_lib.h b/lp_lib.h
index 2ef654f..7b06ef8 100644
--- a/lp_lib.h
+++ b/lp_lib.h
@@ -104,7 +104,7 @@
 /* Specify use of the basic linear algebra subroutine library                */
 /* ------------------------------------------------------------------------- */
 #define libBLAS                  2        /* 0: No, 1: Internal, 2: External */
-#define libnameBLAS        "myBLAS"
+#define libnameBLAS        "/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Versions/Current/libBLAS.dylib"
 
 
 /* Active inverse logic (default is optimized original etaPFI)               */
