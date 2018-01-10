class Ess < Formula
  desc "Emacs Speaks Statistics"
  homepage "https://ess.r-project.org/"
  url "https://ess.r-project.org/downloads/ess/ess-15.09-2.tgz"
  version "15.09-2"
  sha256 "706c41237e1edf33a369902f503bb25254b2bbb750b9ed1adee244e875264afb"

  bottle do
    cellar :any_skip_relocation
    sha256 "33487613d5e6495e90bb0ef9c67769643e45ad01df1783bcf7b238517f687fa6" => :el_capitan
    sha256 "faafee99a5a6b3715bce1dcb310313e0396cf29669178545086a7898f6935728" => :yosemite
    sha256 "ae72a98f8f4131a2cde8219f53df51d6470839eaa1299331fb13d3a8fd7c4f5e" => :mavericks
  end

  depends_on :emacs => "23"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/".emacs").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (require 'ess-site)
    EOS
    (testpath/"test.r").write <<-EOS.undent
      foo(a,
      b)
    EOS
    system "emacs", "-Q", "--batch", "-l", testpath/".emacs",
           "test.r", "--eval", "(ess-indent-exp)", "-f", "save-buffer"

    expected = <<-EOS.undent
      foo(a,
          b)
    EOS
    assert_equal expected, (testpath/"test.r").read
  end
end
