
clc; clear; format compact; idFig = 1; close all;

ID_SCENARIO = -1;

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

sID = myGridLib.getIdOnGrid(map,5, 2);
tID = myGridLib.getIdOnGrid(map,2, 6);

% -------------------------------------------------------------- show S & T

hold on
[sY, sX] = myGridLib.getCooOnGrid(sID,map);
[tY, tX] = myGridLib.getCooOnGrid(tID,map);
% set(gcf,'color','w');
plot(sX,sY,'og', tX,tY,'or'); %START GREEN | GOAL RED
hold off;

% -----------------------------------------------....-- rectangle selection
% 
% [c1Row, c1Col] = myGridLib.getCooOnGrid(sID,map)
% [c2Row, c2Col] = myGridLib.getCooOnGrid(tID,map)
% 
% minRow = min(c1Row,c2Row)
% maxRow = max(c1Row,c2Row)
% 
% minCol = min(c1Col, c2Col)
% maxCol = max(c1Col, c2Col)
% 
% obstCellIDList = [];
% for i = minRow : maxRow
%     for j= minCol : maxCol
%         if (map(i,j)==1)
%             idCell = myGridLib.getIdOnGrid(map,i,j);
%             obstCellIDList = [obstCellIDList idCell];
%         end
%     end 
% end
%     
% obstCellIDList

% --> %obstCellIDList = myGridLib.findObstCellBetween2Cells(sID,tID,map)

%-------------------------------------------------------------- xycooSquare

hold on;
idCell = 39;
[squareXCoos squareYCoos] = myGridLib.getCellSquareXYCoo(idCell,map)

plot(squareXCoos, squareYCoos,'oy')

%------------------------------------------------------- check intersection

% isInterct = false;
% [sY, sX] = myGridLib.getCooOnGrid(sID,map);
% [tY, tX] = myGridLib.getCooOnGrid(tID,map);
% plot([sX tX],[sY tY],'-y')
% 
% obstCellIDList = myGridLib.findObstCellBetween2Cells(sID,tID,map);
% 
% for obsCellID = obstCellIDList
%    
%     [obsCellXCoo obsCellYCoo] = myGridLib.getCellSquareXYCoo(obsCellID,map);
%     
%     stXCoo = [sX tX];
%     stYCoo = [sY tY];
%     
%     [intX, intY] = polyxpoly(stXCoo, stYCoo, obsCellXCoo, obsCellYCoo);
%     
%     if(size(intX,1) ~= 0)
%         
%         plot(intX, intY,'or');
%         disp(['Collisione cella ID: ' num2str(obsCellID)]);
%         isInterct = true;
%         break
%     end
% end

idC1 = 42;
idC2 = tID;
[isThereInt, idCellInt, intX, intY] = myGridLib.findIntersectionWithObstCell(idC1, idC2, map);

%visual debug
[c1Y, c1X] = myGridLib.getCooOnGrid(idC1,map);
[c2Y, c2X] = myGridLib.getCooOnGrid(idC2,map);
plot([c1X c2X],[c1Y c2Y],'-y');
hold on;
plot(intX,intY,'om');

%----------------------- pathfinding
% cameFrom = myGridLib.aStarAlgorithm(sID, tID, map, idMap);
% [pathCellID] = myGridLib.retrivePath(cameFrom, tID);
% myGridLib.showpath(pathCellID, map, idFig);









