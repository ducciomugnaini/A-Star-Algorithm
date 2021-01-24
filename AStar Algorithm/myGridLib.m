classdef myGridLib
    
    methods (Static)
        
        function mapMtx = readMap(idSample)
            mapName = '';
            switch idSample
                case -4
                    mapName = 'trialTerrainV.txt';
                case -3
                    mapName = 'trialTerrainIV_collinearTest.txt';
                case -2
                    mapName = 'trialTerrainIII_pullingTest.txt';
                case -1
                    mapName = 'trialTerrainII.txt';
                case 0
                    mapName = 'trialTerrain.txt';
                case 1
                    mapName = 'AcrosstheCape.txt';
                case 2
                    mapName = 'Archipelago.txt';
                case 3
                    mapName = 'ArcticStation.txt';
                case 4
                    mapName = 'Aurora.txt';
                case 5
                    mapName = 'Backwoods.txt';
                case 6
                    mapName = 'BigGameHunters.txt';
                case 7
                    mapName = 'BlackLotus.txt';
                case 8
                    mapName = 'BlastFurnace.txt';
                case 9
                    mapName = 'BrokenSteppes.txt';
                case 10
                    mapName = 'Brushfire.txt';
            end
            
            fileID = fopen(mapName,'r');
            formatSpec = '%s';
            mapCell = textscan(fileID,formatSpec,'Delimiter',' ');
            
            numCells = size(mapCell{1},1);
            sizeSingleCell = size(mapCell{1}{8},2);
            
            mapMtx = [];
            
            mapMtx = [ones(1,sizeSingleCell+6); ones(1,sizeSingleCell+6); ones(1,sizeSingleCell+6)];
            for i = 8:numCells % <- 7 row for map details
                
                %currRow = mapCell{1}{i}(1:sizeSingleCell) ~= '.';
                
                currRow = ones(1,sizeSingleCell);
                for j = 1:sizeSingleCell
                    if(mapCell{1}{i}(j) == '.')
                       %metto a 0 se è walkable 
                       currRow(j) = 0;
                    end
                end
                
                mapMtx = [mapMtx; [ [1 1 1] currRow [1 1 1]]];
            end
            mapMtx = [mapMtx; ones(1,sizeSingleCell+6); ones(1,sizeSingleCell+6); ones(1,sizeSingleCell+6)];
        end
        
        function idMap = initIDMap(map)
            
            [m,n] = size(map);
            idMap = zeros(m,n);
            id = 1;
            for i = 1:m
                for j = 1:n
                    idMap(i,j) = id;
                    id = id +1;
                end
            end
            
        end
        
        function adjMtx = initAdjMtx(map, idMap)
            
            [m,n] = size(map);
            
            adjMtx = sparse(m*n, m*n);
            
            for i=1:m
                disp(i)
                for j=1:n
                    
                    if(map(i,j) ~= 1) %no obstacle in current cell
                        
                        currID = idMap(i,j);
                        
                        %North check
                        if(i>1 && map(i-1,j)==0)
                            northID = idMap(i-1,j);
                            adjMtx(currID,northID) = 1;
                        end
                        
                        %North-Est check
%                         if(i>1 && j<n && map(i-1,j+1)==0)
%                             northEstID = idMap(i-1,j+1);
%                             adjMtx(currID,northEstID) = 1.4;
%                         end
                        
                        %Est check
                        if(j<n && map(i,j+1)==0 )
                            estID = idMap(i,j+1);
                            adjMtx(currID,estID) = 1;
                        end
                        
                        %South-Est check
%                         if(i<m && j<n && map(i+1,j+1)==0)
%                             southEstID = idMap(i+1,j+1);
%                             adjMtx(currID,southEstID) = 1.4;
%                         end
                        
                        %South check
                        if(i<m && map(i+1,j)==0)
                            southID = idMap(i+1,j);
                            adjMtx(currID,southID) = 1;
                        end
                        
                        %South-West check
%                         if(i<m && j>1 && map(i+1,j-1)==0)
%                             soutWestID = idMap(i+1,j-1);
%                             adjMtx(currID,soutWestID) = 1.4;
%                         end
                        
                        %West Check
                        if(j>1 && map(i,j-1)==0)
                            westID = idMap(i,j-1);
                            adjMtx(currID,westID) = 1;
                        end
                        
                        %North-West check
%                         if(i>1 && j>1 && map(i-1,j-1)==0)
%                             northWestID = idMap(i-1,j-1);
%                             adjMtx(currID,northWestID) = 1.4;
%                         end
                        
                    end
                end
            end
            
        end
        
        function [neighListIDs, weightList] = getNeighboursFromAdjMtx(adjMtx,idCell)
            
            neighListIDs = [];
            weightList = [];
            [m,n] = size(adjMtx);
            
            for j=1:n
                if(adjMtx(idCell,j) ~= 0)
                    neighListIDs = [neighListIDs j];
                    weightList = [weightList adjMtx(idCell,j)];
                end
            end
            
        end
        
        %DIAGONAL MOVE SETTINGS
        function [neighListIDs, weightList] = getNeighbours(idCell, map, idMap)
            
            [m,n] = size(map);
            neighListIDs = [];
            weightList = [];
            costStreightMove = 1;
            
            diagMove = true;
            if(diagMove)
                costDiagonalMove = 1.4;
            end
            
            [i,j] = myGridLib.getCooOnGrid(idCell, map);
            
            if(map(i,j) ~= 1)
               
                %North check
               if(i>1 && map(i-1,j)==0)
                   neighListIDs = [neighListIDs idMap(i-1,j)];
                   weightList = [weightList costStreightMove];
               end
               
               %North-East check
               if(diagMove)
                   if(i>1 && j<n && map(i-1, j+1)==0)
                       neighListIDs = [neighListIDs idMap(i-1, j+1)];
                       weightList = [weightList costDiagonalMove];
                   end
               end
               
               %Est check
               if(j<n && map(i, j+1)==0)
                   neighListIDs = [neighListIDs idMap(i, j+1)];
                   weightList = [weightList costStreightMove];
               end
               
               %South-Est check
               if(diagMove)
                   if(i<m && j <n && map(i+1,j+1)==0)
                       neighListIDs = [neighListIDs idMap(i+1, j+1)];
                       weightList = [weightList costDiagonalMove];
                   end
               end
               
               %South check
               if(i<m && map(i+1,j)==0)
                   neighListIDs = [neighListIDs idMap(i+1, j)];
                   weightList = [weightList costStreightMove];
               end
               
               %South-West check
               if(diagMove)
                   if(i<m && j>1 && map(i+1,j-1)==0)
                       neighListIDs = [neighListIDs idMap(i+1, j-1)];
                       weightList = [weightList costDiagonalMove];
                   end
               end
               
               %West check
               if(j>1 && map(i, j-1)==0)
                   neighListIDs = [neighListIDs idMap(i, j-1)];
                   weightList = [weightList costStreightMove];
               end
               
               %North-west check
               if(diagMove)
                   if(i>1 && j>1 && map(i-1,j-1)==0)
                       neighListIDs = [neighListIDs idMap(i-1, j-1)];
                       weightList = [weightList costDiagonalMove];
                   end
               end
               
            end
            
        end%_getNeighbours
        
        function [ prioIDs, prioVals ] = priorityPut(prioIDs, prioVals, nodeID, nodePrio)
            
            n = size(prioIDs,2);
            
            if(n == 0)
                prioIDs = [prioIDs nodeID];
                prioVals = [prioVals nodePrio];
                return
            end
            
            if(nodePrio <= prioVals(1))
                prioIDs = [nodeID prioIDs(1:n)];
                prioVals = [nodePrio prioVals(1:n)];
                return
            end
            
            for i = 1:n
                
                curr = prioVals(i);
                
                succ = inf;
                if(i < n)
                    succ = prioVals(i+1);
                end
                
                
                if(curr <= nodePrio  && nodePrio <= succ)
                    
                    prioIDs = [prioIDs(1:i) nodeID prioIDs(i+1:n)];
                    prioVals = [prioVals(1:i) nodePrio prioVals(i+1:n)];
                    
                    return
                end
                
            end
        end
        
        function [ id, prioIDs, prioVals ] = priorityGet(prioIDs, prioVals)
            
            id = prioIDs(1);
            
            numElem = size(prioIDs,2);
            if(numElem == 1)
                prioIDs = [];
                prioVals = [];
            else
                prioIDs = prioIDs(2:numElem);
                prioVals = prioVals(2:numElem);
            end
            
        end
        
        % i - grid row number
        % j - grid column number
        function id = getIdOnGrid(map,i,j)
            
            [m,n] = size(map);
            
            if(i == 1)
                id = j;
            else
                id = (i-1)*n + j;
            end
            
        end
        
        function [row, col] = getCooOnGrid(idCell, map)
           
            [m,n] = size(map);
            idCell = double(idCell);
            
            if(idCell <= n)
                row = 1.0;
                col = idCell;
            else
                row = floor(idCell/n);
                col = mod(idCell,n);
                if(col == 0)
                    col = n;
                else
                   row = row + 1.0; 
                end
            end
            
        end
        
        function h = manatthanHeuristic(id1, id2, map)
            
            [x1, y1] = myGridLib.getCooOnGrid(id1, map);
            [x2, y2] = myGridLib.getCooOnGrid(id2, map);
            
            h = abs(x1-x2) + abs(y1-y2);
            
        end
        
        function cameFrom = aStarAlgorithmAdjMtx(sID, tID, adjMtx, map)
            
            numCell = size(adjMtx,1);
            prioIDs = [];
            prioVals = [];
            cameFrom = zeros(1,numCell);
            costSoFar = ones(numCell)*inf;
            
            [prioIDs, prioVals] = myGridLib.priorityPut(prioIDs, prioVals, sID, 0);
            
            cameFrom(sID) = inf;
            costSoFar(sID) = 0;
            
            while size(prioIDs,2) ~= 0 
                
               [currID, prioIDs, prioVals] = myGridLib.priorityGet(prioIDs, prioVals);
                
               if(currID == tID)
                   return
               end
               
               [neighListID, weightList] = myGridLib.getNeighbours(adjMtx,currID);
                  
               for i = 1:size(neighListID,2)
                   
                   nextID = neighListID(i);
                   newCostToNext = costSoFar(currID) + weightList(i);
                   
                   if(newCostToNext < costSoFar(nextID))
                       costSoFar(nextID) = newCostToNext;
                       
                       priority = newCostToNext + myGridLib.manatthanHeuristic(nextID,tID, map);
                       [prioIDs, prioVals] = myGridLib.priorityPut(prioIDs, prioVals, nextID, priority);
                       
                       cameFrom(nextID) = currID;
                   end
                   
               end
                
            end
            
        end%_aStarAlgorithmAdjMtx
        
        function cameFrom = aStarAlgorithm(sID, tID, map, idMap)
            
            numCell = size(map,1)*size(map,2);
            prioIDs = [];
            prioVals = [];
            cameFrom = containers.Map('KeyType','int32','ValueType','int32');
            costSoFar = containers.Map('KeyType','int32','ValueType','int32');
            
            [prioIDs, prioVals] = myGridLib.priorityPut(prioIDs, prioVals, sID, 0);
            
            cameFrom(sID) = -1;
            costSoFar(sID) = 0;
            
            while size(prioIDs,2) ~= 0 
                
               [currID, prioIDs, prioVals] = myGridLib.priorityGet(prioIDs, prioVals);
                
               if(currID == tID)
                   return
               end
               
               [neighListID, weightList] = myGridLib.getNeighbours(currID, map, idMap);
                  
               for i = 1:size(neighListID,2)
                   
                   nextID = neighListID(i);
                   newCostToNext = costSoFar(currID) + weightList(i);
                   
                   if(~costSoFar.isKey(nextID) || newCostToNext < costSoFar(nextID))
                       
                       costSoFar(nextID) = newCostToNext;
                       
                       priority = newCostToNext + myGridLib.manatthanHeuristic(nextID,tID, map);
                       [prioIDs, prioVals] = myGridLib.priorityPut(prioIDs, prioVals, nextID, priority);
                       
                       cameFrom(nextID) = currID;
                   end
                   
               end
                
            end
            
        end%_aStarAlgorithm
        
        function [pathCellIDList] = retrivePath(cameFrom, tID)
            pathCellIDList = [];
            currID = tID;
            while currID ~= -1
                pathCellIDList = [currID pathCellIDList];
                currID = cameFrom(currID);
            end
            
        end
        
        function showMap(map, idFig)
%             map = flipud(map);
            [m,n] = size(map);
            
            figHandler = figure(idFig);
            
            set(gca,'Xtick',1:1:n) %grid grain
            set(gca,'Ytick',1:1:m) %grid grain
            axis equal
            grid on
            box on
            set(gcf,'color','w');
            axis([0 n 0 m]);
            hold on;
            for i=1:m
                for j=1:n
                    if(map(i,j)==1)
%                         plot([j-0.5],[i-0.5],'or');
                        rectangle('Position',[j-1 i-1 1 1],'EdgeColor','r');
                    end
                end 
            end
            hold off;
            
        end%_showMap
        
        function showpath(pathCellIDList, map, idFigure, pathColorCode)
           
            xCoo = [];
            yCoo = [];
            for idCell = pathCellIDList
                [y, x] = myGridLib.getCooOnGrid(idCell, map);
                % x = x-0.5;
                % y = y-0.5;
                xCoo = [xCoo x];
                yCoo = [yCoo y];
            end
            
            figHandler = figure(idFigure);
            hold on;
            plot(xCoo, yCoo, ['-' pathColorCode]);
            hold off;
        end%_showpath
        
        function obstCellIDList = findObstCellBetween2Cells(c1_ID, c2_ID, map)
            
            [rowLim, colLim] = size(map);
            
            [c1Row, c1Col] = myGridLib.getCooOnGrid(c1_ID,map);
            [c2Row, c2Col] = myGridLib.getCooOnGrid(c2_ID,map);
            
            %--- Row bounding
            minRow = min(c1Row,c2Row);
            if(minRow < 1)
               minRow = 1; 
            end
            if(minRow > rowLim)
                minRow = size(map,1);
            end
            
            maxRow = max(c1Row,c2Row);
            if(maxRow < 1)
                maxRow = 1;
            end
            if(maxRow > rowLim)
               maxRow =  size(map,1);
            end
            
            %--- Column bounding
            minCol = min(c1Col, c2Col);
            if(minCol < 1)
               minCol = 1; 
            end
            if(minCol > colLim)
                minCol = colLim;
            end
            maxCol = max(c1Col, c2Col);
            
            obstCellIDList = [];
            for i = minRow : maxRow
                for j= minCol : maxCol
                    if (map(i,j) == 1)
                        idCell = myGridLib.getIdOnGrid(map,i,j);
                        obstCellIDList = [obstCellIDList idCell];
                    end
                end
            end
        end%_selectObstCellBetween2Cells
        
        function [squareXCoos, squareYCoos] = getCellSquareXYCoo(idCell,map)
            [y, x] = myGridLib.getCooOnGrid(idCell,map);
            squareXCoos = [x+0.5 x-0.5 x-0.5 x+0.5 x+0.5];
            squareYCoos = [y+0.5 y+0.5 y-0.5 y-0.5 y+0.5];
        end
        
        function [isInterct, obsCellID, intX, intY]  = findIntersectionWithObstCell(c1_ID, c2_ID, map)
            
            %init values
            isInterct = false; intX = inf; intY = inf;
            
            [c1Y, c1X] = myGridLib.getCooOnGrid(c1_ID,map);
            [c2Y, c2X] = myGridLib.getCooOnGrid(c2_ID,map);
            c1_c2_XCoo = [c1X c2X];
            c1_c2_YCoo = [c1Y c2Y];
            
            obstCellIDList = myGridLib.findObstCellBetween2Cells(c1_ID,c2_ID,map);
            
            for obsCellID = obstCellIDList
                
                [obsCellXCoo, obsCellYCoo] = myGridLib.getCellSquareXYCoo(obsCellID,map);
                
                [intX, intY] = polyxpoly(c1_c2_XCoo, c1_c2_YCoo, obsCellXCoo, obsCellYCoo);
                
                if( ...
                    (size(intX,1) > 1 && (intX(1) ~= intX(2) && intY(1) ~= intY(2))) || ...
                    (size(intX,1) == 1 && (...
                                            (intX(1) ~= obsCellXCoo(1) && intY(1) ~= obsCellYCoo(1)) ||  ... 
                                            (intX(1) ~= obsCellXCoo(2) && intY(1) ~= obsCellYCoo(2)) ||  ... 
                                            (intX(1) ~= obsCellXCoo(3) && intY(1) ~= obsCellYCoo(3)) ||  ... 
                                            (intX(1) ~= obsCellXCoo(4) && intY(1) ~= obsCellYCoo(4))...
                                           )...
                     )...
                  ) 
                    %avoiding case of tangent segment on a square angle
                    isInterct = true;
                    return
                end
                
                [yCurrCell, xCurrCell] = myGridLib.getCooOnGrid(obsCellID,map);
                %check internal segment in square
                if(size(intX,1) == 0 && ...
                    xCurrCell-0.5 <= c1X && c1X <= xCurrCell+0.5 && ...
                    yCurrCell-0.5 <= c1Y && c1Y <= yCurrCell+0.5 && ...
                    xCurrCell-0.5 <= c2X && c2X <= xCurrCell+0.5 && ...
                    yCurrCell-0.5 <= c2Y && c2Y <= yCurrCell+0.5 ...
                    )
                    isInterct = true;
                    
                    intX = xCurrCell;
                    intY = yCurrCell;
                    
                    return
                end
            end
            
        end%_findIntersectionWithObstCell
            
        function [adjPathCellIDs] = classicStringPulling(pathCellIDs, map)
            
            fromIndex = size(pathCellIDs, 2);
            
            fromNodeId  = -1;
            toNodeId    = -1;
            
            while(fromNodeId ~= pathCellIDs(1) && fromNodeId ~= pathCellIDs(2))
                
                for toIndex = fromIndex-2 : -1 : 1
                    
                    fromNodeId  = pathCellIDs(fromIndex);
                    toNodeId    = pathCellIDs(toIndex);
                    
                    [thereIsInt, idCellInt, intX, intY] = myGridLib.findIntersectionWithObstCell(fromNodeId, toNodeId, map);
                    
                    if(thereIsInt)
                        pathCellIDs = [pathCellIDs(1:toIndex+1) pathCellIDs(fromIndex:size(pathCellIDs,2))];
                        fromIndex = toIndex +1;
                        break;
                    end%_if
                    
                end%_for
                
                if(toIndex == 1 && ~thereIsInt)
                    pathCellIDs = [pathCellIDs(1) pathCellIDs(fromIndex:size(pathCellIDs,2))];
                end
                
            end%_while
            
            adjPathCellIDs = pathCellIDs;

        end%_classicStringPulling
        
        function [adjPathCellIDs] = removeCollinearNodes(pathCellIDs, map)
            
            fromIndex = size(pathCellIDs, 2);
            toIndex = -1;
            while(toIndex ~= 1)
                
                for toIndex = fromIndex-2 : -1 : 1
                    
                    fromNodeId  = pathCellIDs(fromIndex);
                    toNodeId    = pathCellIDs(toIndex);
                    midNodeId   = pathCellIDs(toIndex+1);
                    
                    [fromNodeY, fromNodeX]  = myGridLib.getCooOnGrid(fromNodeId,map);
                    [toNodeY, toNodeX]      = myGridLib.getCooOnGrid(toNodeId,  map);
                    [midNodeY, midNodeX]     = myGridLib.getCooOnGrid(midNodeId, map);
                    
                    coll = mathUtilityLight.collinearPointsCheck(fromNodeX, fromNodeY, toNodeX, toNodeY, [midNodeX ; midNodeY]);
                    
                    if(~coll)
                        pathCellIDs = [pathCellIDs(1:toIndex+1) pathCellIDs(fromIndex:size(pathCellIDs,2))];
                        fromIndex = toIndex +1;
                        break;
                    end%_if
                    
                end%_for
                
                if(toIndex == 1 && coll)
                    pathCellIDs = [pathCellIDs(1) pathCellIDs(fromIndex:size(pathCellIDs,2))];
                end
                
            end%_while
            
            adjPathCellIDs = pathCellIDs;
            
        end%_removeCollinearNodes
        
        %!!! -> To call after:
        % 1 - COLLINEAR POINTS ELIMINATION
        % 2 - INFLECTION POINTS INSERTION
        function [pos] = computePosOnSegment(indexCurrSeg, pathCellIDs, map)
            %!!! Returned pos is inverted (image are with reflected axis)
            % pos VALUES:
            % => -1 destra
            % => +1 sinistra
            % => 0 on segment
            
            % segment enumeration starts from 1
            nSeg = size(pathCellIDs,2)-1;
            
            % getting extremes coordinate of currSeg(° <----> °)
            [y1, x1] = myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg),map);
            [y2, x2] = myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg+1),map);
            
            if(indexCurrSeg ~= 1)
                %prev check
                [y0, x0] = myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg-1),map);
                
                pos = mathUtilityLight.posizionePuntoRispettoALinea(x1,y1,x2,y2,x0,y0);
                if(pos ~= 0)
                    return;
                end
            end
            
            if(indexCurrSeg ~= nSeg)
                %succ check
                [y3, x3] = myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg+2),map);
                
                pos = mathUtilityLight.posizionePuntoRispettoALinea(x1,y1,x2,y2,x3,y3);
                if(pos ~= 0)
                    return;
                end
            end
            
            if pos == 0
                warning(['Collinear points are present on path on SEGMENT #' num2str(indexCurrSeg) '======> COLLINEAR DELETE IS REQUIRED']);
            end
              
        end
        
        function [pos] = computePosOnSegment_XYPath(indexCurrSeg, pathXY)
            
            % segment enumeration starts from 1
            nSeg = size(pathXY,2)-1;
            
            % getting extremes coordinate of currSeg(° <----> °)
            x1 = pathXY(1,indexCurrSeg);
            y1 = pathXY(2,indexCurrSeg);
            
            x2 = pathXY(1,indexCurrSeg+1);
            y2 = pathXY(2,indexCurrSeg+1);
            
            if(indexCurrSeg ~= 1)
                %prev check
                x0 = pathXY(1,indexCurrSeg-1);
                y0 = pathXY(2,indexCurrSeg-1);
                
                pos = mathUtilityLight.posizionePuntoRispettoALinea(x1,y1,x2,y2,x0,y0);
                if(pos ~= 0)
                    return;
                end
            end
            
            if(indexCurrSeg ~= nSeg)
                %succ check
                x3 = pathXY(1,indexCurrSeg+2);
                y3 = pathXY(2,indexCurrSeg+2);
                
                pos = mathUtilityLight.posizionePuntoRispettoALinea(x1,y1,x2,y2,x3,y3);
                if(pos ~= 0)
                    return;
                end
            end
            
            if pos == 0
                warning(['Collinear points are present on path on SEGMENT #' num2str(iSeg) '======> COLLINEAR DELETE IS REQUIRED']);
            end
        end
        
        % return parallel segment coos
        % paralSegCoo = [aX aY bX bY];
        function [aX, aY, bX, bY] = computeParallelSegmentCoos(indexCurrSeg, pos, pathCellIDs, map)
            %---- define parallel segment
            % getting extremes coordinate of currSeg(° <----> °)
            [y1, x1] = myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg),map);
            [y2, x2] = myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg+1),map);
            
            if(pos == 1)
                posOnFirstExtr = 'left';
                posOnSecondExtr = 'right';
            else
                posOnFirstExtr = 'right';
                posOnSecondExtr = 'left';
            end
            % parallel segmento to x1y1 -----> x2y2
            [aX aY] = mathUtilityLight.calcolaPerpendicolareAlPrimoSide(x1,y1,x2,y2,0.5,posOnFirstExtr);
            [bX bY] = mathUtilityLight.calcolaPerpendicolareAlPrimoSide(x2,y2,x1,y1,0.5,posOnSecondExtr);
            
        end
        
        function [aX, aY, bX, bY] = computeParallelSegmentCoos_XYPath(indexCurrSeg, pos, dist, pathXY)
            %---- define parallel segment
            % getting extremes coordinate of currSeg(° <----> °)
            x1 = pathXY(1,indexCurrSeg);
            y1 = pathXY(2,indexCurrSeg);
            
            x2 = pathXY(1,indexCurrSeg+1);
            y2 = pathXY(2,indexCurrSeg+1);
            
            if(pos == 1)
                posOnFirstExtr = 'left';
                posOnSecondExtr = 'right';
            else
                posOnFirstExtr = 'right';
                posOnSecondExtr = 'left';
            end
            % parallel segmento to x1y1 -----> x2y2
            [aX, aY] = mathUtilityLight.calcolaPerpendicolareAlPrimoSide(x1,y1,x2,y2, dist,posOnFirstExtr);
            [bX, bY] = mathUtilityLight.calcolaPerpendicolareAlPrimoSide(x2,y2,x1,y1, dist,posOnSecondExtr);
            
        end
        
        % return the new extremes coordinate for parallel segment
        % cutted on intersection with previous and next adjacent segment 
        % of indexCurrSeg
        function [newAX, newAY, newBX, newBY] = computeCuttedParSeg(aX, aY, bX, bY, indexCurrSeg, pathCellIDs, map)
            % segment enumeration starts from 1
            nSeg = size(pathCellIDs,2)-1;
            
            % coos of current segment
            [y1, x1] = myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg),map);
            [y2, x2] = myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg+1),map);
            
            if(indexCurrSeg == 1)
                [y3, x3] =  myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg+2),map);
                [newBX, newBY] = mathUtilityLight.lineIntersection(aX,aY,bX,bY, x2,y2,x3,y3,false);
                
                newAX = aX;
                newAY = aY;
            end
            
            if(indexCurrSeg == nSeg)
                [y0, x0] =  myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg-1),map);
                [newAX, newAY] = mathUtilityLight.lineIntersection(aX,aY,bX,bY, x0,y0,x1,y1,false);
                
                newBX = bX;
                newBY = bY;
            end
            
            if(1 < indexCurrSeg && indexCurrSeg < nSeg)
                [y0, x0] =  myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg-1),map);
                [y3, x3] =  myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg+2),map);
                
                collPrec = mathUtilityLight.collinearPointsCheck(x1,y1, x2, y2, [x0; y0]);
                collSucc = mathUtilityLight.collinearPointsCheck(x1,y1, x2, y2, [x3; y3]);
                
                if(~collPrec)
                    [newAX, newAY] = mathUtilityLight.lineIntersection(aX,aY,bX,bY, x0,y0,x1,y1,false);
                    newBX = bX;
                    newBY = bY;
                end
                if(~collSucc)
                    [newBX, newBY] = mathUtilityLight.lineIntersection(aX,aY,bX,bY, x2,y2,x3,y3,false);
                    newAX = aX;
                    newAY = aY;
                end
            end
            
        end
        
        function [newAX, newAY, newBX, newBY] = computeCuttedParSeg_XYPath(aX, aY, bX, bY, indexCurrSeg, pathXY)
            % segment enumeration starts from 1
            nSeg = size(pathXY,2)-1;
            
            % getting extremes coordinate of currSeg(° <----> °)
            x1 = pathXY(1,indexCurrSeg);
            y1 = pathXY(2,indexCurrSeg);
            
            x2 = pathXY(1,indexCurrSeg+1);
            y2 = pathXY(2,indexCurrSeg+1);
            
            newAX = aX;
            newAY = aY;
            
            newBX = bX;
            newBY = bY;
            
            if(indexCurrSeg == 1)
                % [y3, x3] =  myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg+2),map);
                x3 = pathXY(1,indexCurrSeg + 2);
                y3 = pathXY(2,indexCurrSeg + 2);
                
                [newBX, newBY] = mathUtilityLight.lineIntersection(aX,aY,bX,bY, x2,y2,x3,y3,false);
                
            end
            
            if(indexCurrSeg == nSeg)
                % [y0, x0] =  myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg-1),map);
                x0 = pathXY(1,indexCurrSeg - 1);
                y0 = pathXY(2,indexCurrSeg - 1);
                
                [newAX, newAY] = mathUtilityLight.lineIntersection(aX,aY,bX,bY, x0,y0,x1,y1,false);
                
            end
            
            if(1 < indexCurrSeg && indexCurrSeg < nSeg)
                % [y0, x0] =  myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg-1),map);
                x0 = pathXY(1,indexCurrSeg - 1);
                y0 = pathXY(2,indexCurrSeg - 1);
                
                %[y3, x3] =  myGridLib.getCooOnGrid(pathCellIDs(indexCurrSeg+2),map);
                x3 = pathXY(1,indexCurrSeg + 2);
                y3 = pathXY(2,indexCurrSeg + 2);
                
                collPrec = mathUtilityLight.collinearPointsCheck(x1,y1, x2, y2, [x0; y0]);
                collSucc = mathUtilityLight.collinearPointsCheck(x1,y1, x2, y2, [x3; y3]);
                
                if(~collPrec)
                    [newAX, newAY] = mathUtilityLight.lineIntersection(aX,aY,bX,bY, x0,y0,x1,y1,false);
                    
                end
                if(~collSucc)
                    [newBX, newBY] = mathUtilityLight.lineIntersection(aX,aY,bX,bY, x2,y2,x3,y3,false);
                end
            end
            
        end
        
        function [xCoo, yCoo] = findCellCooByRounding(x,y)
            % dividing integer from fractional part
            % point on intersections belong to the upper diagonal cell
            % exp: (1.5, 1.5) \in [2, 2]
            % point on cell boundary belong to the upper cell
            % exp: (1,   1.5) \in [1, 2]
            
            %-- XCoo
            integX = floor(x);
            fractX = x-integX;
            
            if(0.5 <= fractX)
                xCoo = floor(x)+1;
            else
                xCoo = floor(x);
            end
            
            %-- YCoo
            integY = floor(y);
            fractY = y-integY;
           
            if(0.5 <= fractY)
                yCoo = floor(y)+1;
            else
                yCoo = floor(y);
            end
            
            
        end
        
        % return [2x(#n+#inflex)] [XCoos; YCoos]
        function pathXY = inflectionPointsInsertion(pathCellIDs, map)
            % convertion from ID_CELL_LIST -> XY_COO_LIST(2xn)
            pathXY = [];
            for i = 1 : size(pathCellIDs,2)
                [ay, ax] = myGridLib.getCooOnGrid(pathCellIDs(i),map);
                pathXY = [pathXY [ax; ay]];
            end
            
            % flex points insertion
            % [pathX pathY] = myGridLib.insertInflectionPoints(pathCellIDs, map);
            i = 1;
            n = size(pathXY,2);
            while(i <= n-3)
                ax = pathXY(1,i);
                ay = pathXY(2,i);
                
                bx = pathXY(1,i+1);
                by = pathXY(2,i+1);
                
                cx = pathXY(1,i+2);
                cy = pathXY(2,i+2);
                
                dx = pathXY(1,i+3);
                dy = pathXY(2,i+3);
                
                posA = mathUtilityLight.posizionePuntoRispettoALinea(bx, by, cx, cy, ax, ay);
                posD = mathUtilityLight.posizionePuntoRispettoALinea(bx, by, cx, cy, dx, dy);
                
                if((posA == 1 && posD == -1) || (posA == -1 && posD == 1))
                    
                    bcX = bx*0.5 + cx*0.5;
                    bcY = by*0.5 + cy*0.5;
                    
                    pathXY = [pathXY(:,1:i+1) [bcX; bcY] pathXY(:,i+2:n)];
                    
                    i = i+2;
                    n = size(pathXY,2);
                    
                else
                    i = i+1;
                end
            end
 
        end%_inflectionPointsInsertion
        
        function condition = defineEndCondition(indexCurrSeg, pathXY)
            
            nSeg = size(pathXY,2)-1;
            
            condition = '';
            
            if(indexCurrSeg == 1 || indexCurrSeg == nSeg)
                if(indexCurrSeg == 1 )
                    x0 = pathXY(1,1);
                    y0 = pathXY(2,1);
                    
                    x1 = pathXY(1,2);
                    y1 = pathXY(2,2);
                    
                    x2 = pathXY(1,3);
                    y2 = pathXY(2,3);
                end
                
                if(indexCurrSeg == nSeg)
                    x0 = pathXY(1,nSeg-1);
                    y0 = pathXY(2,nSeg-1);
                    
                    x1 = pathXY(1,nSeg);
                    y1 = pathXY(2,nSeg);
                    
                    x2 = pathXY(1,nSeg+1);
                    y2 = pathXY(2,nSeg+1);
                end
                alpha_1 = mathUtilityLight.calcolaAngolazione(x0,y0,x1,y1,x2,y2);
                
                if(alpha_1 < 90)
                    condition = 'convergente';
                    %condition = 'END_ON_PARAL_SEG_LENGHT';
                else
                    condition = 'divergente';
                    %condition = 'END_ON_NUM_ITERATION';
                end
            end
            if(1 < indexCurrSeg && indexCurrSeg < nSeg )
                x0 = pathXY(1,indexCurrSeg-1);
                y0 = pathXY(2,indexCurrSeg-1);
                
                x1 = pathXY(1,indexCurrSeg);
                y1 = pathXY(2,indexCurrSeg);
                
                x2 = pathXY(1,indexCurrSeg+1);
                y2 = pathXY(2,indexCurrSeg+1);
                
                x3 = pathXY(1,indexCurrSeg+2);
                y3 = pathXY(2,indexCurrSeg+2);
                
                alpha_1 = mathUtilityLight.calcolaAngolazione(x0,y0,x1,y1,x2,y2);
                alpha_2 = mathUtilityLight.calcolaAngolazione(x1,y1,x2,y2,x3,y3);
                
                if(alpha_1 < 90 && alpha_2 < 90)
                    condition = 'convergente';
                    %condition = 'END_ON_PARAL_SEG_LENGHT';
                else
                    condition = 'divergente';
                    %condition = 'END_ON_NUM_ITERATION';
                end
            end
            
        end%_defineEndCondition
        
        function maxDist = computeMaxDist(indexCurrSeg, pathXY,segment_type)
            
            nSeg = size(pathXY,2)-1;
            
            if(strcmp(segment_type,'convergente'))
                x1 = pathXY(1,indexCurrSeg);
                y1 = pathXY(2,indexCurrSeg);
                x2 = pathXY(1,indexCurrSeg+1);
                y2 = pathXY(2,indexCurrSeg+1);
                
                if(...
                        indexCurrSeg == 1 || ...
                        mathUtilityLight.collinearPointsCheck(x1,y1, x2, y2, [pathXY(1,indexCurrSeg-1); pathXY(2,indexCurrSeg-1)])...
                        )
                    [x0, y0] = mathUtilityLight.calcolaPerpendicolareAlPrimoSide(x1,y1,x2,y2, 0.5, 'left');
                else
                    x0 = pathXY(1,indexCurrSeg-1);
                    y0 = pathXY(2,indexCurrSeg-1);
                end
                
                if(...
                        indexCurrSeg == nSeg || ...
                        mathUtilityLight.collinearPointsCheck(x1,y1, x2, y2, [pathXY(1,indexCurrSeg+2); pathXY(2,indexCurrSeg+2)])...
                        )
                    [x3, y3] = mathUtilityLight.calcolaPerpendicolareAlPrimoSide(x2,y2,x1,y1, 0.5, 'left');
                else
                    x3 = pathXY(1,indexCurrSeg+2);
                    y3 = pathXY(2,indexCurrSeg+2);
                end
                
                [intX, intY] = mathUtilityLight.lineIntersection(x0,y0, x1,y1, x2,y2, x3,y3, false);
                
                maxDist = mathUtilityLight.pointLineDistance(x1,y1, x2,y2, intX,intY, true);
                
                %plot(intX, intY,'or'); % <- Debug intersection points of
                %adjacent segments (prec and succ segments)
                
            else % caso divergente
                maxDist = 10;
            end
            
        end
        
    end%_static_methods
    
end
