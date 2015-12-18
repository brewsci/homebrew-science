class Ess < Formula
  desc "Emacs Speaks Statistics"
  homepage "http://ess.r-project.org/"
  url "http://ess.r-project.org/downloads/ess/ess-15.09-2.tgz"
  version "15.09-2"
  sha256 "706c41237e1edf33a369902f503bb25254b2bbb750b9ed1adee244e875264afb"

  depends_on :emacs => "23"

  def install
    system "make", "install", "PREFIX=#{prefix}", "EMACS=#{ENV["EMACS"]}",
           "LISPDIR=#{elisp}"
  end

  def caveats; <<-EOS.undent
      To load the package, add

        (require 'ess-site)

      to your '~/.emacs' file.
    EOS
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
    system "emacs", "-l", testpath/".emacs", "--batch", "test.r",
           "--eval", "(ess-indent-exp)",
           "-f", "save-buffer"
    assert_equal "    b)", File.read("test.r").lines.last.chomp
  end
end
