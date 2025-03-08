# Installing Python 3.X on Debian
Compiling Python from the source allows you to install the latest Python version and customize the build options. However, you won’t be able to maintain your Python installation through the apt package manager.

Building Python 3.X on Debian is a relatively straightforward process and will only take a few minutes.

1. Install the dependencies necessary to build Python:
```bash
sudo apt update
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
```
2. Download the latest release’s source code from the Python download page with wget (make sure to cange to desired version):
```bash
wget https://www.python.org/ftp/python/3.X.X/Python-3.X.X.tgz
```
3. Once the download is complete, extract the gzipped archive :
```bash
tar -xf Python-3.X.X.tgz
```
4. Navigate to the Python source directory and execute the configure script:
```bash
cd Python-3.X.X
./configure --enable-optimizations
```
  The --enable-optimizations option optimizes the Python binary by running multiple tests. This makes the build process slower.

  The script runs a number of checks to make sure all of the dependencies on your system are present.

5. Start the Python 3.X build process:
```bash
make -j 2
```
  For faster build time, modify the -j to correspond to the number of cores in your processor. You can find the number by typing `nproc`.

6. When the build process is complete, install the Python binaries by typing:
```bash
sudo make altinstall
```
  We’re using altinstall instead of install because later will overwrite the default system python3 binary.

That’s it. Python 3.X has been installed and ready to be used. To verify it, type:
```bash
python3.X --version
```
The output should show the Python version:
```bash
Python 3.X.X
```
