class Prodigal < Formula
  desc "Microbial gene finding program"
  homepage "http://prodigal.ornl.gov/"
  url "https://github.com/hyattpd/Prodigal/archive/v2.6.3.tar.gz"
  sha256 "89094ad4bff5a8a8732d899f31cec350f5a4c27bcbdd12663f87c9d1f0ec599f"
  head "https://github.com/hyattpd/Prodigal.git"
  # doi "10.1186/1471-2105-11-119"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "04589946de1192c7473c63a8f933fc421a5d5d5eebd61f8f659895dd18c0d87c" => :yosemite
    sha256 "78e0d323775b06739c84984b79c3444bc40d0c1ec3f89d8d5a410f53e48539a5" => :mavericks
    sha256 "0c0a4cfa497f3521023f15d7f3e94f197db313e432368489cd9ed80734f3ae50" => :mountain_lion
    sha256 "846a3edf95d0577fed82fc37aab60c1affaa5101f0dbf9bbd9b7aa3c4d164c8d" => :x86_64_linux
  end

  def install
    system "make"
    mv "prodigal2", "prodigal" if build.head?
    bin.install "prodigal"
    doc.install "CHANGES", "LICENSE", "VERSION", "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prodigal -v 2>&1")
  end
end
