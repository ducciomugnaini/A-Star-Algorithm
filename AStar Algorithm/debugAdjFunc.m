
clc; clear; format compact;
idFig = 1;

%--- Map Init

m = 5;
n = 6;
map = zeros(m,n);
map(2,2:3) = 1;
map(3,4) = 1;
map(5,4) = 1;
map

idMap = myGridLib.initIDMap(map)

[ids, wights] = myGridLib.getNeighbours(27,map,idMap)