clc; clear; format compact; idFig = 1; close all;

ID_SCENARIO = -3;

% ------------------------------------------------------------ retrieve map
map = myGridLib.readMap(ID_SCENARIO);

% ---------------------------------------------------------------- init map
idMap = myGridLib.initIDMap(map);

figHandler = figure(1);
axis;
allAxesInFigure = findall(figHandler,'type','axes');
axesHandler = allAxesInFigure(1);
hold on
set(axesHandler,'OuterPosition',[-0.14    0.0    1.25    1.00]);
set(figHandler,'units','normalized','outerposition',[0 0 0.62 0.85]);

imshow(map);

%---------------------------------------------------------------- test path

% Test #1
% pathCellIDs = [14 15 28 29 30 31 19 20 8 9 10 23 36 37 38];

% Test #2
pathCellIDs = [4 3 2 1 15 29 43 44 45 46 47 35 23 24 25 12];


%show test path
myGridLib.showpath(pathCellIDs, map, 1, 'oy');

%---------------------------------------------------------- collinear check
% fromIndex = size(pathCellIDs, 2);
% toIndex = -1;
% while(toIndex ~= 1)
%     
%     for toIndex = fromIndex-2 : -1 : 1
%         
%         fromNodeId  = pathCellIDs(fromIndex);
%         toNodeId    = pathCellIDs(toIndex);
%         midNodeId   = pathCellIDs(toIndex+1);
%         
%         [fromNodeY, fromNodeX]  = myGridLib.getCooOnGrid(fromNodeId,map);
%         [toNodeY, toNodeX]      = myGridLib.getCooOnGrid(toNodeId,  map);
%         [midNodeY, midNodeX]     = myGridLib.getCooOnGrid(midNodeId, map);
%         
%         coll = mathUtilityLight.collinearPointsCheck(fromNodeX, fromNodeY, toNodeX, toNodeY, [midNodeX ; midNodeY]);
%         
%         if(~coll)
%             pathCellIDs = [pathCellIDs(1:toIndex+1) pathCellIDs(fromIndex:size(pathCellIDs,2))];
%             fromIndex = toIndex +1;
%             break;
%         end%_if
%         
%     end%_for
%     
%     if(toIndex == 1 && coll)
%         pathCellIDs = [pathCellIDs(1) pathCellIDs(fromIndex:size(pathCellIDs,2))];
%     end
%     
% end%_while
% 

adjPathCellIDs = myGridLib.removeCollinearNodes(pathCellIDs, map);

myGridLib.showpath(adjPathCellIDs, map, 1, '*m');








