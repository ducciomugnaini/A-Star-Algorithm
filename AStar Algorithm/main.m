
close all; clc; clear; format compact; idFig = 1;

ID_SCENARIO = 1;
MANUAL_ST   = 0;

% ------------------------------------------------------------ retrieve map

map = myGridLib.readMap(ID_SCENARIO);

% ---------------------------------------------------------------- init map

idMap = myGridLib.initIDMap(map);
% imshow(map);
imshow(map);

% -------------------------------------------- Coos Setting | START -> GOAL
% -------------------------------------------- (COLUMN, ROW) = [y,x]
switch ID_SCENARIO
    case 1
        
%         [x, y] = ginput(1)
%         sID = myGridLib.getIdOnGrid(map, floor(y), floor(x));
        sID = myGridLib.getIdOnGrid(map,56, 723);       
        
        % tID = myGridLib.getIdOnGrid(map,108, 684);    % near
        % tID = myGridLib.getIdOnGrid(map,310, 667);    % Slow near path
        tID = myGridLib.getIdOnGrid(map,577, 312);      % Best far fast
        % tID = myGridLib.getIdOnGrid(map,574, 101);    % Mid far fast
        % tID = myGridLib.getIdOnGrid(map,736, 57);     % Far
        
    case 2
        
        sID = myGridLib.getIdOnGrid(map,15, 499);
        tID = myGridLib.getIdOnGrid(map,472, 180);    
        
    case 3
        
        sID = myGridLib.getIdOnGrid(map,732, 663);
        tID = myGridLib.getIdOnGrid(map,540, 491);    
        
    case 4
        
        sID = myGridLib.getIdOnGrid(map,689, 768);
        tID = myGridLib.getIdOnGrid(map,426, 981); 
end


% -------------------------------------------------------------- show S & T

hold on
[sY, sX] = myGridLib.getCooOnGrid(sID,map);
[tY, tX] = myGridLib.getCooOnGrid(tID,map);
set(gcf,'color','w');
plot(sX,sY,'og', tX,tY,'or'); %START GREEN | GOAL RED
hold off;

% ----------------------------------------------------------------- A* Call

disp 'A* Algorithm';
cameFrom = myGridLib.aStarAlgorithm(sID, tID, map, idMap);
[pathCellID] = myGridLib.retrivePath(cameFrom, tID);

myGridLib.showpath(pathCellID, map, idFig,'y');% <------ show original path

% -------------------------------------------------- remove collinear nodes

disp 'Removing collinear';
AdjPathCellIDs_I = myGridLib.removeCollinearNodes(pathCellID, map);

% ---------------------------------------------------------- string pulling

disp 'String Pulling';
AdjPathCellIDs_II = myGridLib.classicStringPulling(AdjPathCellIDs_I, map);
disp (['#Nodes ' num2str(size(AdjPathCellIDs_II,2))]);

% -------------------------------------------------- remove collinear nodes

disp 'Removing collinear';
AdjPathCellIDs_III = myGridLib.removeCollinearNodes(AdjPathCellIDs_II, map);
disp (['#Nodes ' num2str(size(AdjPathCellIDs_III,2))]);


myGridLib.showpath(AdjPathCellIDs_III, map, idFig,'c');% <------ final path




