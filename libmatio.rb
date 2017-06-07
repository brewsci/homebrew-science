class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.10/matio-1.5.10.tar.gz"
  sha256 "41209918cebd8cc87a4aa815fed553610911be558f027aee54af8b599c78b501"
  revision 2

  bottle do
    cellar :any
    sha256 "34fae6eb55f4e89cac866d742280c61c646acc7f01df1c3634905c2b5814e2ac" => :sierra
    sha256 "56609562e31c329cfb00b1dd1afcb6e451eb90988e1d85c5eb3397f7db368a56" => :el_capitan
    sha256 "e3cbabed01e29d33f1144c3a826688cc5508f00800dcdf39bc86a172887fb1d3" => :yosemite
  end

  depends_on "hdf5"

  # sample MATLAB file from http://web.uvic.ca/~monahana/eos225/matlab_tutorial/tutorial_5/working_with_data.html
  resource "test_mat_file" do
    url "https://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
    sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib=/usr
      --enable-extended-sparse=yes
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --enable-mat73=yes
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("test_mat_file")
    mv "poc_data.mat.sfx", "test.mat"
    (testpath/"not-a-mat-file.mat").write("Not a mat file\n")
    (testpath/"mat.c").write <<-'EOS'.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <matio.h>
      #include <errno.h>
      int main(int argc, char **argv)
      {
        mat_t *matfp;
        errno = 0;
        matfp = Mat_Open(argv[1], MAT_ACC_RDONLY);
        if (NULL == matfp) {
          printf("errno %d", errno);
          return EXIT_FAILURE;
        }
        printf("errno %d", errno);
        Mat_Close(matfp);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    assert_equal "errno 2", shell_output("./mat no-such-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat not-a-mat-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat test.mat")
  end
end
