class Libgpkg < Formula
  desc "SQLite 3 extension that provides a minimal OGC GeoPackage implementation"
  homepage "https://bitbucket.org/luciad/libgpkg"
  url "https://bitbucket.org/luciad/libgpkg/get/0.9.16.tar.gz"
  sha256 "be43a2725f5fcecbe3b1baf95e6c45847f7a9a3d8ac20978b9e11aa765e8d980"

  head "https://bitbucket.org/luciad/libgpkg", :using => :hg, :branch => "default"

  option "with-tests", "Run unit tests after build, prior to install"

  depends_on "cmake" => :build
  depends_on "geos" => :recommended
  depends_on "ruby" if build.with? "tests"

  env :std

  def install
    args = std_cmake_args
    args << "-DGPKG_GEOS=ON" if build.with? "geos"
    args << "-DGPKG_TEST=ON" if build.with? "tests"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      IO.popen("make test") { |io| io.each { |s| print s } } if build.with? "tests"
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    Custom SQLite command-line shell that autoloads static GeoPackage extension:
    #{opt_prefix}/bin/gpkg

    Make sure to review Usage (extension loading) and Function Reference docs:
    https://bitbucket.org/luciad/libgpkg/wiki/Home
  EOS
  end
end
