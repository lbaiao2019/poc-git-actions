cd layer
pip3 install -r requirements.txt -t  "$PWD"/packages/python/lib/python3.8/site-packages/
rm -f /tmp/application_libs.zip
cd packages
zip -r /tmp/application_libs.zip .
cd ..
rm -rf packages/