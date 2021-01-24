
clc; clear; format compact;
idFig = 1;

%--- Map Init

% m = 5;
% n = 6;
% map = zeros(m,n);
% map(2,2:3) = 1;
% map(3,4) = 1;
% map(5,4) = 1;
% map

%--- retrieve map
map = myGridLib.readMap(1);

%--- idMap Init
idMap = myGridLib.initIDMap(map);
% myGridLib.showMap(map, idFig);
imshow(map);

%---- AdjMtx init
adjMtx = myGridLib.initAdjMtx(map, idMap);

%---- A* Alg
sID = myGridLib.getIdOnGrid(map,1,1);
tID = myGridLib.getIdOnGrid(map,5,5);

cameFrom = myGridLib.aStarAlgorithm(sID, tID, adjMtx, map);

%---- Show path
[pathCellID] = myGridLib.retrivePath(cameFrom, tID)
myGridLib.showpath(pathCellID, map, idFig);






