class Root6 < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch"
  url "https://root.cern.ch/download/root_v6.10.04.source.tar.gz"
  version "6.10.04"
  sha256 "461bde21d78608422310f04c599e84ce8dfbdd91caf12c2a54db6c01f8228f5b"
  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "741b9cd7788959d1551c197d4e9f176b4b7132a751c2be01448b02ce34032e15" => :sierra
    sha256 "c4807e5094105293aae5618a2e436cf38c71d52c557c2f0086a61ccc80c41a0f" => :el_capitan
    sha256 "e8085e02a4548abb91fcd7e96f02778dba2415c28bed2aeaa59fd7c6767e4309" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "xrootd" => :optional
  depends_on "fftw" => :optional
  depends_on "openssl" => :recommended # use homebrew's openssl
  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on :x11 => :recommended if OS.linux?
  depends_on :fortran => :recommended # enabled by default since 6.08.00
  depends_on "gsl" => :recommended
  # root5 obviously conflicts, simply need `brew unlink root`
  conflicts_with "root"
  # cling also takes advantage
  needs :cxx11

  def config_opt(opt, pkg = opt)
    "-D#{opt}=#{build.with? pkg ? "ON" : "OFF"}"
  end

  def install
    dylib = OS.mac? ? "dylib" : "so"

    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    inreplace Dir["config/roots.in", "config/thisroot.*sh",
                  "etc/proof/utils/pq2/setup-pq2",
                  "man/man1/setup-pq2.1", "README/INSTALL", "README/README"],
      /bin.thisroot/, "libexec/thisroot"

    # ROOT does the following things by default that `brew audit` doesn't like:
    #  1. Installs libraries to lib/
    #  2. Installs documentation to man/
    # Homebrew expects:
    #  1. Libraries in lib/<some_folder>
    #  2. Documentation in share/man
    # so we set some flags to match what Homebrew expects
    args = %W[
      -Dgnuinstall=ON
      -DCMAKE_INSTALL_ELISPDIR=#{share}/emacs/site-lisp/#{name}
      -Dbuiltin_freetype=ON
      -Droofit=ON
      -Dminuit2=ON
      #{config_opt("ssl", "openssl")}
      #{config_opt("xrootd")}
      #{config_opt("mathmore", "gsl")}
      #{config_opt("fortran")}
      #{config_opt("fftw3", "fftw")}
    ]

    if build.with?("python3") && build.with?("python")
      # Root6 Does not support building both python 2 and 3 versions
      odie "Root6: Does not support building both python 2 and 3 wrappers"
    elsif build.with?("python") || build.with?("python3")
      python_executable = `which python`.strip if build.with? "python"
      python_executable = `which python3`.strip if build.with? "python3"
      python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
      python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
      python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp

      # CMake picks up the system's python dylib, even if we have a brewed one.
      if File.exist? "#{python_prefix}/Python"
        python_library = "#{python_prefix}/Python"
      elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
        python_library = "#{python_prefix}/lib/lib#{python_version}.a"
      elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.#{dylib}"
        python_library = "#{python_prefix}/lib/lib#{python_version}.#{dylib}"
      elsif File.exist? "#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.#{dylib}"
        python_library = "#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.so"
      else
        odie "No libpythonX.Y.{dylib|so|a} file found!"
      end
      args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
      args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
      args << "-DPYTHON_LIBRARY='#{python_library}'"
    end
    args << "-Dpython=" + (build.with?("python") ? "ON" : "OFF")
    args << "-Dpython3=" + (build.with?("python3") ? "ON" : "OFF")

    # ROOT forbids running CMake in the root of the source directory,
    # so run in a subdirectory (there's already one called `build`)
    mkdir "build_dir" do
      system "cmake", "..", *(std_cmake_args + args)
      system "make", "install"
    end

    libexec.mkpath
    mv Dir["#{bin}/*.*sh"], libexec
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For bash users:
      . $(brew --prefix root6)/libexec/thisroot.sh
    For zsh users:
      pushd $(brew --prefix root6) >/dev/null; . libexec/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source `brew --prefix root6`/libexec/thisroot.csh
    EOS
  end

  test do
    (testpath/"test.C").write <<-EOS.undent
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS
    (testpath/"test.bash").write <<-EOS.undent
      . #{libexec}/thisroot.sh
      root -l -b -n -q test.C
    EOS
    assert_equal "\nProcessing test.C...\nHello, world!\n",
      `/bin/bash test.bash`
  end
end
