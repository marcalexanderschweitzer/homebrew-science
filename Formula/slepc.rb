# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
 class Slepc < Formula
  desc ""
  homepage ""
  url "http://slepc.upv.es/download/distrib/slepc-3.10.2.tar.gz"
  sha256 "0594972293f6586458a54b7c1e1121b311a9c9449060355d52bb3bf09ad6812b"

  option "with-blopex", "Download blopex library"

  depends_on "marcalexanderschweitzer/science/petsc"
  depends_on "open-mpi"
  depends_on "gcc"
  depends_on "hdf5"
  depends_on "arpack" => ["with-mpi"]

    def install
    ENV["SLEPC_DIR"] = Dir.getwd

    arch_real = "real"
    ENV["PETSC_ARCH"] = arch_real
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{arch_real}"
    system "./configure", "--with-arpack-dir=#{Formula["arpack"].opt_lib}", "--with-arpack-flags=-lparpack,-larpack",
                          "--prefix=#{prefix}/#{arch_real}",
                          "--with-clean=true"
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"

    arch_real = "complex"
    ENV["PETSC_ARCH"] = arch_complex
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}"
    system "./configure", "--with-arpack-dir=#{Formula["arpack"].opt_lib}", "--with-arpack-flags=-lparpack,-larpack",
                          "--prefix=#{prefix}/#{arch_complex}",
                          "--with-clean=true"
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"

    # Link what we need.
    petsc_arch = ((build.include? "complex") ? arch_complex : arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"],
                            "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    doc.install "docs/slepc.pdf", Dir["docs/*.htm"], "docs/manualpages" # They're not really man pages.
    pkgshare.install "share/slepc/datafiles"

    # install some tutorials for use in test block
    pkgshare.install "src/eps/examples/tutorials"
  end

  def caveats; <<~EOS
    Set your SLEPC_DIR to #{opt_prefix}/real or #{opt_prefix}/complex.
    Fortran modules are in #{opt_prefix}/real/include and #{opt_prefix}/complex/include.
    EOS
  end

  test do
    cp_r prefix/"share/slepc/tutorials", testpath
    Dir.chdir("tutorials") do
      system "mpicc", "ex1.c", "-I#{opt_include}", "-I#{Formula["petsc"].opt_include}", "-L#{Formula["petsc"].opt_lib}", "-lpetsc", "-L#{opt_lib}", "-lslepc", "-o", "ex1"
      system "mpirun -np 3 ex1 2>&1 | tee ex1.out"
      `cat ex1.out | tail -3 | awk '{print $NF}'`.split.each do |val|
        assert val.to_f < 1.0e-8
      end
    end
  end
end