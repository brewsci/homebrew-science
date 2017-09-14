class Gatk < Formula
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk/"
  url "https://github.com/broadgsa/gatk-protected/archive/3.6.tar.gz"
  sha256 "f2f1311136e06189b0f44a35a3c92fa700ddcbf3d6c4760517ec7bbe08eafce0"
  head "https://github.com/broadgsa/gatk-protected.git"
  # doi "10.1101/gr.107524.110"
  # tag "bioinformatics"

  bottle :disable, "See https://github.com/Homebrew/homebrew-science/pull/4428"

  depends_on :java
  depends_on "maven" => :build

  def install
    # Fix error on Circle CI.
    # Error: Could not find or load main class org.codehaus.plexus.classworlds.launcher.Launcher
    ENV.delete "M2_HOME"

    system "mvn", "package", "-Dmaven.repo.local=${PWD}/repo"
    java = share/"java"
    mkdir_p java
    cp "target/GenomeAnalysisTK.jar", java
    bin.write_jar_script java/"GenomeAnalysisTK.jar", "gatk"
    prefix.install_metafiles
  end

  def caveats; <<-EOS.undent
    GATK Official Release Repository: contains the core MIT-licensed GATK
    framework, plus "protected" tools restricted to non-commercial use only
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/gatk --help 2>&1", 0)
  end
end
