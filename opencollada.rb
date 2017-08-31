class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.59.tar.gz"
  sha256 "638ce67a3f8fe0ce99b69ba143f1ecf80813b41ed09438cfbb07aa913f1b89d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed369db9ad0ef17ef778ba57c35b7f0b917ba9491e891b39ebdced59c3323fc5" => :sierra
    sha256 "ecdd70143559eee18ff93cf009b9a6cb7809874303728bc44dd2421d8db922e2" => :el_capitan
    sha256 "c9e53bade536e817972df15b3302014485069deeb146f7aaac3aea3127df8feb" => :yosemite
    sha256 "0117739401b79ecc8f3f9b48ee40d9a4d5703ba87c19d556b4da840b93a593bb" => :x86_64_linux
  end

  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "libxml2"
    depends_on "pcre"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      prefix.install "bin"
      Dir.glob("#{bin}/*.xsd") { |p| rm p }
    end
  end

  test do
    system "#{bin}/OpenCOLLADAValidator"
  end
end
