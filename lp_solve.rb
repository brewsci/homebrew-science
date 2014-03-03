require 'formula'

def numpy_include_dir
  "#{`python -c "import numpy.distutils.misc_util as u; print(u.get_numpy_include_dirs())[0]"`.strip}"
end

class NumpyHasHeaders < Requirement
  def satisfied?
    not Dir["#{numpy_include_dir}/numpy/*.h"].empty?
  end

  def fatal?
    true
  end

  def message
    s = <<-EOS.undent
      Apple ships NumPy without the header files :-/
      To fix this, do either of the following options:
    EOS
    unless MacOS::CLT.installed?
      s += "  * Install the 'Command Line Tools for Xcode' via the Preferences in Xcode.\n"
    end
    s += "  * `brew tap homebrew/python` and `brew install numpy`\n"
    s += "  * `pip install numpy`\n"
    s
  end
end

class LpSolve < Formula
  homepage 'http://sourceforge.net/projects/lpsolve/'
  url 'https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.0_source.tar.gz'
  version '5.5.2.0'  # automatic version parser spits out "solve" as version
  sha1 'e2830053cf079839b9ce21662cbc886ac6d31c80'

  option 'python', 'Python extension to interface with lp_solve'
  depends_on 'numpy' => :python if build.include? 'python'
  depends_on NumpyHasHeaders.new if build.include? 'python'

  resource 'lp_solve_python' do
    # 'http://lpsolve.sourceforge.net/5.5/Python.htm'
    url 'https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.0_Python_source.tar.gz'
    sha1 '058cced6b6a27cc160c9c5054c6b94b0eae6d989'
    version '5.5.2.0'
  end

  def patches
    # Prefer OS X's fast BLAS implementation (patch stolen from fink-project)
    DATA
  end

  def install
    # Thanks to superenv, we don't have to care if the ccc.osx build script
    # tells the compiler stupid things. And Xcode-only works like charm.

    # Clang on :snow_leopard does not ignore `-Wno-long-double` and errors out.
    ["configure", "configure.ac", "demo/ccc.osx", "lp_solve/ccc.osx",
     "lpsolve55/ccc.osx", "lpsolve55/cccLUSOL.osx"].each do |f|
      inreplace f, '-Wno-long-double', ''
    end if MacOS.version <= :snow_leopard

    cd 'lpsolve55' do
      system "sh ccc.osx # lpsolve55 library"
      lib.install Dir['./bin/osx64/*.a']
      lib.install Dir['./bin/osx64/*.dylib']
    end

    cd 'lp_solve' do
      system "sh ccc.osx # lp_solve executable"
      bin.install './bin/osx64/lp_solve'
    end

    # Note, the demo does not build with lpsolve55. Upstream issue.

    include.install Dir['*.h']

    if build.include? 'python' then
      # In order to install into the Cellar, the dir must exist and be in the
      # PYTHONPATH.
      temp_site_packages = lib/which_python/'site-packages'
      mkdir_p temp_site_packages
      ENV['PYTHONPATH'] = temp_site_packages
      args = [
        "--no-user-cfg",
        "install",
        "--force",
        "--verbose",
        "--install-scripts=#{share}/python",
        "--install-lib=#{temp_site_packages}",
        "--record=installed-files.txt"
      ]

      resource("lp_solve_python").stage do
        cd 'extra/Python' do
          # On OS X malloc there is <sys/malloc.h> and <malloc/malloc.h>
          inreplace "hash.c", "#include <malloc.h>", "#include <sys/malloc.h>"
          # We know where the lpsolve55 lib is...
          inreplace "setup.py", "LPSOLVE55 = '../../lpsolve55/bin/ux32'", "LPSOLVE55 = '#{lib}'"
          # Correct path to lpsolve's include dir and go the official way to find numpy include_dirs
          inreplace "setup.py",
                    "include_dirs=['../..', NUMPYPATH],",
                    "include_dirs=['#{include}', '#{numpy_include_dir}'],"
          inreplace 'setup.py', "(NUMPY, '1')", "('NUMPY', '1')"
          # Even their version number is broken ...
          inreplace "setup.py", 'version = "5.5.0.9",', "version = '#{version}',"

          system "python", "setup.py", *args

          # Save the examples
          (share/'lp_solve').install Dir['ex*.py'], 'lpdemo.py', 'Python.htm'
        end
      end
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

    Python examples and doc are installed to #{HOMEBREW_PREFIX}/share/lp_solve.
    EOS
  end if build.include? 'python'

  test do
    input = <<-EOS.undent
      max: 143 x + 60 y;

      120 x + 210 y <= 15000;
      110 x + 30 y <= 4000;
      x + y <= 75;
    EOS
    (testpath/'input.lp').write(input)
    output = `#{bin}/lp_solve -S3 input.lp`
    #puts output
    match = output =~ /Value of objective function: 6315\.6250/
    raise if match.nil?
    # if build.include? 'python'
    #   system 'python', "#{HOMEBREW_PREFIX}/share/lp_solve/lpdemo.py"
    # end
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
