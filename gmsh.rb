require 'formula'

class GmshSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system *args
    super *args + ['--username', 'gmsh', '--password', 'gmsh']
  end
end

class Gmsh < Formula
  homepage 'http://geuz.org/gmsh'
  url 'http://geuz.org/gmsh/src/gmsh-2.8.5-source.tgz'
  sha1 '352671f95816440ddb2099478f3e9f189e40e27a'

  head 'https://geuz.org/svn/gmsh/trunk', :using => GmshSvnStrategy

  depends_on 'cmake' => :build
  depends_on 'fltk' => :optional

  def install
    # In OS X, gmsh sets default directory locations as if building a
    # binary. These locations must be reset so that they make sense
    # for a Homebrew-based build.
    args = std_cmake_args + ["-DENABLE_OS_SPECIFIC_INSTALL=0",
                             "-DGMSH_BIN=#{bin}",
                             "-DGMSH_LIB=#{lib}",
                             "-DGMSH_DOC=#{share}/gmsh",
                             "-DGMSH_MAN=#{man}"]

    # Make sure native file dialogs are used
    args << "-DENABLE_NATIVE_FILE_CHOOSER=ON"

    # Build a shared library such that others can link
    args << "-DENABLE_BUILD_LIB=ON"
    args << "-DENABLE_BUILD_SHARED=ON"

    # Todo: enable PETSc and SLEPc.
    args << "-DENABLE_PETSC=OFF"
    args << "-DENABLE_SLEPC=OFF"
    args << "-DENABLE_FLTK=OFF" if build.without? "fltk"
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  def test
    system "#{bin}/gmsh", "#{share}/doc/gmsh/tutorial/t1.geo", "-parse_and_exit"
  end
end
