#!/bin/bash
set -x #echo on
#############################
#
# copyright 2018 Open Connectivity Foundation, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#############################
CURPWD=`pwd`

#path of the code
code_path=OCFDeviceBuilder

# linux pi
# default
ARCH=`uname -m`

echo "using architecture: $ARCH"

cd ..
# clone the repo
git clone https://github.com/openconnectivityfoundation/DeviceBuilder.git
# get the initial example 
cp DeviceBuilder/DeviceBuilderInputFormat-file-examples/input-lightdevice.json example.json


# create the generation script
echo "#!/bin/bash" > gen.sh
echo "cd DeviceBuilder" >> gen.sh
echo "sh ./DeviceBuilder_IotivityLiteServer.sh ../example.json  ../device_output \"oic.d.light\"" >> gen.sh
echo "cd .." >> gen.sh
echo "# copying source code to compile location" >> gen.sh
echo "cp ./device_output/code/simpleserver.c ./iotivity-constrained/apps/device_builder_server.c " >> gen.sh
echo "cp ./device_output/code/server_introspection.dat.h ./iotivity-constrained/include/server_introspection.dat.h " >> gen.sh


# create the build script
echo "#!/bin/bash" > build.sh
echo "cd iotivity-constrained/port/linux" >> build.sh
echo "#uncomment next line for building without security" >> build.sh
echo "#scons examples/${code_path} SECURED=0" >> build.sh
echo "make device_builder_server" >> build.sh
echo "cd ../../.." >> build.sh

# create the edit script
echo "#!/bin/bash" > edit_code.sh
echo "nano ./iotivity-constrained/apps/device_builder_server.c" >> edit_code.sh

# create the run script
echo "#!/bin/bash"> run.sh
echo 'CURPWD=`pwd`'>> run.sh
echo "cd ./iotivity-constrained/port/linux" >> run.sh
echo "pwd" >> run.sh
echo "ls" >> run.sh
echo "./device_builder_server" >> run.sh
echo 'cd $CURPWD' >> run.sh

# create the reset script
echo "#!/bin/bash"> reset.sh
echo "rm -f ./iotivity-constrained/port/linux/device_builder_server_creds" >> reset.sh


cd $CURPWD

echo "making the example directory"
#mkdir -p ../iotivity/examples/${code_path}
# add the build file
cp ./environment-changes/Makefile ../iotivity-constrained/port/linux/Makefile


chmod a+x ../*.sh