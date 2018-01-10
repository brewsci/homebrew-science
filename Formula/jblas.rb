class Jblas < Formula
  homepage "https://mikiobraun.github.io/jblas"
  url "https://mikiobraun.github.io/jblas/jars/jblas-1.2.3.jar"
  sha256 "e9328d4e96db6b839abf50d72f63626b2309f207f35d0858724a6635742b8398"

  def install
    (share / "java").install "jblas-#{version}.jar" => "jblas.jar"
  end
end
