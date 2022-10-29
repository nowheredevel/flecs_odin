cd flecs
git pull origin master
cmake .
msbuild flecs.sln
cd ..
REM Debug builds
cp flecs/Debug/flecs.dll lib/debug/

REM Release builds (TODO)