cd flecs
cmake .
msbuild flecs.sln
cd ..
cp flecs/Debug/flecs_static.lib lib/