
clc; clear; format compact; idFig = 1; close all;

ID_SCENARIO = -4;

% ------------------------------------------------------------ retrieve map
map = myGridLib.readMap(ID_SCENARIO);

%adding futher obstacles for specific debug
map(6, 11) = 1;
map(11, 20) = 1;
map(19, 17) = 1;
map(19, 21) = 1;
map(14, 6) = 1;

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
% pathCellIDs = [40 28 29 30 44 45 46 32 33 34 35 47 48 49 36];

% Test #1
% pathCellIDs = [40 2 6 43 21 23 37 38 51]; % ON  SCENARIO -3

%show test path
c0 = myGridLib.getIdOnGrid(map, 13,10);
c1 = myGridLib.getIdOnGrid(map, 11,9); c2 = myGridLib.getIdOnGrid(map,10,15);
c3 = myGridLib.getIdOnGrid(map, 12,15); c4 = myGridLib.getIdOnGrid(map,15,17);
c5 = myGridLib.getIdOnGrid(map, 16, 23); c6 = myGridLib.getIdOnGrid(map,11,24);
c7 = myGridLib.getIdOnGrid(map, 9,30); c8 = myGridLib.getIdOnGrid(map,14,33);
c9 = myGridLib.getIdOnGrid(map, 18,35); c10 = myGridLib.getIdOnGrid(map,15,38);

pathCellIDs = [c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10];

%------------------------------------------------------------- find heights

%--- convertion from IDCELL_LIST -> XY_COO
pathXY = myGridLib.inflectionPointsInsertion(pathCellIDs, map);

hold on
plot(pathXY(1,:), pathXY(2,:),'-*r');


% segment enumeration starts from 1
nSeg = size(pathXY,2)-1;
heights = zeros(1,nSeg);
hold on;
for indexCurrSeg = 1 : nSeg
    
    disp(['Seg # ' num2str(indexCurrSeg)]);
    
    %---- compute parallel segment type
    
    segment_type = myGridLib.defineEndCondition(indexCurrSeg, pathXY)
    
    %---- compute SIDE of parallel segment
    
    pos = myGridLib.computePosOnSegment_XYPath(indexCurrSeg, pathXY);
    
    %---- compute maxDist
    
    maxDist = myGridLib.computeMaxDist(indexCurrSeg, pathXY,segment_type)
    disp(' ')
    
    %---- iteration on single segment => 
    dist = 1;
    while(dist < maxDist)
    
        %---- compute PARALLEL SEGMENT on computer side
        
        %[aX, aY, bX, bY] = myGridLib.computeParallelSegmentCoos(indexCurrSeg, pos, pathCellIDs, map);
        [aX, aY, bX, bY] = myGridLib.computeParallelSegmentCoos_XYPath(indexCurrSeg, pos, dist, pathXY);
        
        plot(aX, aY,'*m');
        plot(bX, bY,'*c');
        plot([aX bX], [aY bY],'-*y');
        
        %--- compute INTERSECTION between PARALLEL SEGMENT <-> PREC/SUCC
        % getting extremes coordinate of currSeg(° <----> °)
        
        %[newAX, newAY, newBX, newBY] = myGridLib.computeCuttedParSeg(aX, aY, bX, bY, indexCurrSeg, pathCellIDs, map);
        [newAX, newAY, newBX, newBY] = myGridLib.computeCuttedParSeg_XYPath(aX, aY, bX, bY, indexCurrSeg, pathXY);
        plot([newAX newBX],[newAY newBY],'-m');
        
        
        %--- compute INTERSECTION between CUTTED_PARAL_SEG <-> OBST_CELL
        [roundAX, roundAY] = myGridLib.findCellCooByRounding(newAX, newAY);
        [roundBX, roundBY] = myGridLib.findCellCooByRounding(newBX, newBY);
        
        A_CellID = myGridLib.getIdOnGrid(map,roundAY, roundAX);
        B_CellID = myGridLib.getIdOnGrid(map,roundBY, roundBX);
        
        [isInterct, obsCellID, intX, intY]  = myGridLib.findIntersectionWithObstCell(A_CellID, B_CellID, map);
        if(isInterct)
            plot(intX, intY,'*b');
            
            %find nearest square-corner to the current segment => height
            [squareXCoos, squareYCoos] = myGridLib.getCellSquareXYCoo(obsCellID,map);
            
            % getting extremes coordinate of currSeg(° <----> °)
            x1 = pathXY(1,indexCurrSeg);
            y1 = pathXY(2,indexCurrSeg);
            
            x2 = pathXY(1,indexCurrSeg+1);
            y2 = pathXY(2,indexCurrSeg+1);
            
            minDist = 1000000;
            
            for i=1:size(squareXCoos,2)
                
                xCorner = squareXCoos(i);
                yCorner = squareYCoos(i);
                
                currCornDist = mathUtilityLight.pointLineDistance(x1,y1, x2,y2, xCorner,yCorner,true);
                
                if(currCornDist < minDist)
                    minDist = currCornDist;
                end
            end
            heights(indexCurrSeg) = minDist;
            break;
        end
        dist = dist+1;
        
    end
    if(dist == 1)
        heights(indexCurrSeg) = maxDist;
    end
    
    
end



