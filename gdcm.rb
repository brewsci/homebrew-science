class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "http://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.6.3/gdcm-2.6.3.tar.bz2"
  sha256 "7882e880b8b60efc66a492ae3c1c161799340ad62a90d690823b76eb400c0a8f"

  bottle do
    sha256 "5e480698f28f6a3d7e16eeec541feb9b6e0ec24edfe4f3c5c35c11f80895d28d" => :el_capitan
    sha256 "1d046333077cc1f5325247a9f23260cabc1fe6152c75ddd0333e1ad14bcbdf46" => :yosemite
    sha256 "be5cf5f2ffd1d68322a01d22de4f119366fb26cecb9484c801819ec988d804bf" => :mavericks
  end

  patch do
    url "https://gist.githubusercontent.com/tfmoraes/5489a2473c1ed6cc296aa646432a8536/raw/6e912995d89b65d0cc2cb5d9714dd9450d04a768/01_vtkCxxRevisionMacro.patch"
    sha256 "4b21c41c562880ae7e31b075f1b945c19d4e5d27442085953f89b2f27cae99e3"
  end

  patch do
    url "https://gist.githubusercontent.com/tfmoraes/5489a2473c1ed6cc296aa646432a8536/raw/6e912995d89b65d0cc2cb5d9714dd9450d04a768/02_vtkTypeRevisionMacro.patch"
    sha256 "234d9fb4b33fd55b66f0662bb5ea0347caf7c79868c7171de42fdaab8bbb8389"
  end

  patch do
    url "https://gist.githubusercontent.com/tfmoraes/5489a2473c1ed6cc296aa646432a8536/raw/6e912995d89b65d0cc2cb5d9714dd9450d04a768/03_float_double.patch"
    sha256 "9cbe64dd7b518888c1a5c6b3e88f321139806e9078fc9c71abe0ad444008c496"
  end

  patch do
    url "https://gist.githubusercontent.com/tfmoraes/5489a2473c1ed6cc296aa646432a8536/raw/ced7783f695a8156d9ed95559d9026d65c63296c/04_vtkfloatingpoint_app.patch"
    sha256 "a1798438aba1ea0e916aab08436178ebc49b560de373f57eea7c0d1f1184bd17"
  end

  patch do
    url "https://gist.githubusercontent.com/tfmoraes/5489a2473c1ed6cc296aa646432a8536/raw/13c5656edd53c364c624e064b110635c47cf4b64/05_vtk7python.patch"
    sha256 "237aa9bf44157d327c9877cfc57e353919a9d756dd05f52f4ccf6a39ae581af1"
  end

  patch do
    url "https://gist.githubusercontent.com/tfmoraes/5489a2473c1ed6cc296aa646432a8536/raw/13c5656edd53c364c624e064b110635c47cf4b64/06_vtk7apps_examples.patches"
    sha256 "f9184c3f57dbc34179e5bb1a7f1144ffa850f94497add4d782bdffc06577cf8d"
  end

  option "with-check", "Run the GDCM test suite"
  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on "openssl" => :optional

  option :cxx11
  cxx11dep = (build.cxx11?) ? ["c++11"] : []

  depends_on "cmake" => :build
  depends_on "vtk" => [:optional] + cxx11dep
  depends_on "swig" => :build if build.with?("python") || build.with?("python3")

  if build.with?("python") && build.with?("python3")
    raise "Recipe may only be installed for one python type."
  end

  def install
    sourcedir = "#{pwd}/source_files"
    builddir = "#{pwd}/build_files"

    targets = Dir.glob("*")

    mkdir sourcedir
    targets.each do |target|
      mv target, File.join(sourcedir, File.basename(target))
    end
    mkdir builddir do
      args = std_cmake_args

      if build.with?("python") || build.with?("python3")
        python_executable = `which python`.strip if build.with? "python"
        python_executable = `which python3`.strip if build.with? "python3"

        python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
        python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
        python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp
        py_site_packages = "#{lib}/#{python_version}/site-packages"

        args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
        if File.exist? "#{python_prefix}/Python"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.dylib'"
        end
        args << "-DGDCM_WRAP_PYTHON=ON"
        args << "-DGDCM_INSTALL_PYTHONMODULE_DIR='#{py_site_packages}'"
      end

      args << "-DGDCM_BUILD_APPLICATIONS=ON"
      args << "-DGDCM_BUILD_EXAMPLES=ON"
      args << "-DGDCM_BUILD_SHARED_LIBS=ON"
      args << "-DGDCM_BUILD_TESTING=ON" if build.with? "check"
      args << "-DGDCM_USE_VTK=ON" if build.with? "vtk"
      args << "-DGDCM_USE_SYSTEM_OPENSSL=ON" if build.with? "openssl"
      args << sourcedir

      system "cmake", *args

      system "make"
      system "make", "test" if build.with? "check"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gdcminfo", "--version"
  end
end
