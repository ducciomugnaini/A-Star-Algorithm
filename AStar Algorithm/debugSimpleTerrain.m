
close all;clc; clear; format compact;
idFig = 1;

%--- Map Init

%--- retrieve map
map = myGridLib.readMap(0);

%--- idMap Init
idMap = myGridLib.initIDMap(map);
% myGridLib.showMap(map, idFig);
imshow(map);% <- inverte le coordinate automaticamente

%---- A* Alg
sID = myGridLib.getIdOnGrid(map,1,1);
hold on;
plot(1,1,'or');
tID = myGridLib.getIdOnGrid(map,7,10);
plot(7,10,'or');

cameFrom = myGridLib.aStarAlgorithm(sID, tID, map, idMap);

%---- Show path
[pathCellID] = myGridLib.retrivePath(cameFrom, tID)
hold on;
myGridLib.showpath(pathCellID, map, idFig);






