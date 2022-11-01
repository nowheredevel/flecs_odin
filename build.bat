cd flecs
git pull origin master
cmake .
msbuild flecs.sln
cd ..
REM Debug builds
cp flecs/Debug/flecs.dll .

REM Release builds (TODO)