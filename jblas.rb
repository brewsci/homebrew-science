require 'formula'

class Jblas < Formula
  homepage 'http://mikiobraun.github.io/jblas'
  url 'http://mikiobraun.github.io/jblas/jars/jblas-1.2.3.jar'
  sha1 '3c0d35c4e6b8d7ea7bbcbf109fd1863e54f9d061'

  def install
    (share / "java").install "jblas-#{version}.jar" => "jblas.jar"
  end
end
