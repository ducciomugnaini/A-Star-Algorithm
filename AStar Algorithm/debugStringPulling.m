clc; clear; format compact; idFig = 1; close all;

ID_SCENARIO = -2;

% ------------------------------------------------------------ retrieve map
map = myGridLib.readMap(ID_SCENARIO);

% ---------------------------------------------------------------- init map
idMap = myGridLib.initIDMap(map);

figHandler = figure(1);
axis
allAxesInFigure = findall(figHandler,'type','axes');
axesHandler = allAxesInFigure(1);
hold on
set(axesHandler,'OuterPosition',[-0.14    0.0    1.25    1.00]);
set(figHandler,'units','normalized','outerposition',[0 0 0.62 0.85]);
            
imshow(map);

sID = myGridLib.getIdOnGrid(map,8, 1);
tID = myGridLib.getIdOnGrid(map,2, 8);

% -------------------------------------------------------------- show S & T

hold on
[sY, sX] = myGridLib.getCooOnGrid(sID,map);
[tY, tX] = myGridLib.getCooOnGrid(tID,map);
% set(gcf,'color','w');
plot(sX,sY,'og', tX,tY,'or'); %START GREEN | GOAL RED
hold off;

%---------------------------------------------------------------- test path

pathCellIDs = [57 49 41 42 43 35 27 28 29 30 31 32 24 16];

%show test path
myGridLib.showpath(pathCellIDs, map, 1, 'y');


%----------------------------------------------------------- string pulling
% 
% fromIndex = size(pathCellIDs, 2);
% fromNodeId  = -1;
% toNodeId    = -1;
% while(fromNodeId ~= pathCellIDs(1) && fromNodeId ~= pathCellIDs(2))
%     
%     for toIndex = fromIndex-2 : -1 : 1
%         
%         fromNodeId  = pathCellIDs(fromIndex);
%         toNodeId    = pathCellIDs(toIndex);
%         
%         [thereIsInt, idCellInt, intX, intY] = myGridLib.findIntersectionWithObstCell(fromNodeId, toNodeId, map);
%         
%         if(thereIsInt)
%             pathCellIDs = [pathCellIDs(1:toIndex+1) pathCellIDs(fromIndex:size(pathCellIDs,2))];
%             fromIndex = toIndex +1;
%             break;
%         end%_if
%         
%     end%_for
%     
%     if(toIndex == 1 && ~thereIsInt)
%         pathCellIDs = [pathCellIDs(1) pathCellIDs(fromIndex:size(pathCellIDs,2))];
%     end
%     
% end%_while

AdjPathCellIDs = myGridLib.classicStringPulling(pathCellIDs, map);

myGridLib.showpath(AdjPathCellIDs, map, 1,'c');









