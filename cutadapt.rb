class Cutadapt < Formula
  include Language::Python::Virtualenv

  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  # tag "bioinformatics"
  # doi "10.14806/ej.17.1.200"

  url "https://files.pythonhosted.org/packages/47/bf/9045e90dac084a90aa2bb72c7d5aadefaea96a5776f445f5b5d9a7a2c78b/cutadapt-1.11.tar.gz"
  sha256 "11d0af9b39d6d9de6d186f113c7b361c24e7432425b9fa68fb2857a4656890cf"

  head "https://github.com/marcelm/cutadapt.git"

  depends_on :python3

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    assert_match "interleaved", shell_output("#{bin}/cutadapt -h 2>&1")
  end
end
