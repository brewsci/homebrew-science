class Adam < Formula
  desc "Genomics analysis platform with specialized file formats built using Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://repo1.maven.org/maven2/org/bdgenomics/adam/adam-distribution_2.10/0.17.1/adam-distribution_2.10-0.17.1-bin.tar.gz"
  sha256 "30ec40d43e8f2e0ac0690056e2437f2a4af4fad9033f1e41021898b65fa2d986"

  bottle do
    cellar :any
    sha256 "f6dc4e21f9264f9110504445a33a099076c75052d28551ad520377a8356915e4" => :yosemite
    sha256 "5bdd0363cdc6d5dd1656a0c576de3e6ccc76f8b81ac74f6d519236d022703988" => :mavericks
    sha256 "bdcc97aca83ff7a56ac771a038fde3832786d39cb01e4d4fe828a9a6bf4700c2" => :mountain_lion
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
    rm "#{libexec}/bin/adam.bat"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/adam-submit", "buildinfo"
  end
end
