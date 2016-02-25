class Adam < Formula
  desc "Genomics analysis platform with specialized file formats built using Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://repo1.maven.org/maven2/org/bdgenomics/adam/adam-distribution_2.10/0.19.0/adam-distribution_2.10-0.19.0-bin.tar.gz"
  sha256 "9010b198e8fc38de24030a2d00ae86351a6a3af2a3f62b3d21251648e3d60524"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bf8b2311b906535fca1048cfd64fd162b7d2d791a7814adc5d70ed7171b95fe" => :el_capitan
    sha256 "81b36880cc06e0822939358cfa631dae809cd632846e92b7e74d34a38d94a613" => :yosemite
    sha256 "a4cc0fae830a47294b6d83741cbbd5248c3707af8f8a56c418b886c66941424e" => :mavericks
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
