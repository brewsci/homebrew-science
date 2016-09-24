class RubyVersion19 < Requirement
  fatal true
  satisfy(:build_env => false) { `ruby -e 'print RUBY_VERSION'`.strip.to_f >= 1.9 }

  def message; <<-EOS.undent
      Ruby >= 1.9 is required to run tests, which utilize Encoding class.
      Install without `--with-tests` option.
  EOS
  end
end

class Libgpkg < Formula
  homepage "https://bitbucket.org/luciad/libgpkg"
  url "https://bitbucket.org/luciad/libgpkg/get/0.9.16.tar.gz"
  sha256 "be43a2725f5fcecbe3b1baf95e6c45847f7a9a3d8ac20978b9e11aa765e8d980"

  head "https://bitbucket.org/luciad/libgpkg", :using => :hg, :branch => "default"

  option "with-tests", "Run unit tests after build, prior to install"

  depends_on "cmake" => :build
  depends_on "geos" => :recommended
  if build.with? "tests"
    depends_on RubyVersion19
    depends_on "bundler" => :ruby
  end

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

  def caveats; <<-EOS.undent
      Custom SQLite command-line shell that autoloads static GeoPackage extension:
      #{opt_prefix}/bin/gpkg

      Make sure to review Usage (extension loading) and Function Reference docs:
      https://bitbucket.org/luciad/libgpkg/wiki/Home

  EOS
  end
end
