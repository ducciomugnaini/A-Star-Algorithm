clc; clear; format compact;

% 
% %casi limite angoli della mappa
% [ids, weig] = myGridLib.getNeighbours(adjMtx,1)
% [ids, weig] = myGridLib.getNeighbours(adjMtx,6)
% [ids, weig] = myGridLib.getNeighbours(adjMtx,25)
% [ids, weig] = myGridLib.getNeighbours(adjMtx,30)
% 
% %casi con ostacoli presenti
% [ids, weig] = myGridLib.getNeighbours(adjMtx,27)

%------- Debug show map

fileID = fopen('AcrosstheCape.txt','r');
formatSpec = '%s';
mapCell = textscan(fileID,formatSpec,'Delimiter',' ');

numCells = size(mapCell{1},1);
sizeSingleCell = size(mapCell{1}{8},2);

mapMtx = [];
for i = 8:numCells % <- 7 row for map details
    currRow = mapCell{1}{i}(1:sizeSingleCell) == '.';
%     cr2 = mapCell{1}{i}(1:sizeSingleCell) ~= '.';
    mapMtx = [mapMtx; currRow];
end

% myGridLib.showMap(mapMtx, 1)
% imshow(mapMtx);
imshow(mapMtx);
hold on;
plot([65 50],[710 581],'-or')
