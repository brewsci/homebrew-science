class Adam < Formula
  desc "Genomics analysis platform with specialized file formats built using Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://repo1.maven.org/maven2/org/bdgenomics/adam/adam-distribution_2.10/0.19.0/adam-distribution_2.10-0.19.0-bin.tar.gz"
  sha256 "9010b198e8fc38de24030a2d00ae86351a6a3af2a3f62b3d21251648e3d60524"

  bottle do
    cellar :any_skip_relocation
    sha256 "8753269b3b654fe4fa830c517e66c1b9bdd5a7d0ef34a01d500e832d7f18027b" => :el_capitan
    sha256 "9cd5a676b17b44d1b5b0445fb7fca6541032c21d42bef4410a372e5d32594e18" => :yosemite
    sha256 "c35dd18b5c4eba31c57f2e023a10c364495b0cfc5dc01c85da564e40c30a5f7e" => :mavericks
  end

  depends_on "apache-spark"

  head do
    url "https://github.com/bigdatagenomics/adam.git", :shallow => false
    depends_on "maven" => :build
  end

  option "without-check", "Disable build-time checking (not recommended)"

  def install
    if build.head?
      system "mvn", "clean", "install",
                    "-DskipAssembly=True",
                    "-DskipTests=" + (build.with?("check") ? "False" : "True")
      libexec.install Dir["adam-cli/target/appassembler/*"]
    else
      libexec.install Dir["*"]
    end
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/adam-submit", "--version"
  end
end
