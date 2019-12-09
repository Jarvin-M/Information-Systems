# Get the code up and running
sudo apt-get install libgdal-dev
sudo apt-get install python3-tk
gdal-config --version (place version in requirements) it will complain, pip uses 4 version code
python3 -m venv env
which python3 # python from your env
source env/bin/activate

pip3 install -r ./requirements.txt

