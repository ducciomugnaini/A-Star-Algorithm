classdef mathUtilityLight
    % Methods subset of mathUtility library
    
    methods (Static)
        
        function coll = puntoSuRetta(x1,y1,x2,y2,x,y)
           
            
            tol = exp(-6);
            
            if( (abs(x1-x2) <= tol && abs(x2-x) <= tol) ||...
                    (abs(y1-y2) <= tol && abs(y2-y) <= tol) ...
                    )
                %Retta verticale o orizzontale => punto su retta
                coll = true;
                return;
            end
            
            yEq = (y2-y1)/(x2-x1);
            yEq = yEq * (x - x1) + y1;
            
            if(abs(y - yEq) <= tol)
               coll = true;
               return
            end
            
            coll = false;
            
        end%function puntoSuRetta
        
        %check if points in pVector(2xn) are collinear to segment (x1,y1 - x2,y2)
        %return true - all points are collinear
        %return false - otherwise
        function coll = collinearPointsCheck(x1,y1, x2, y2,pVector)
           coll = 1;
            for i = 1:size(pVector,2)
               x = pVector(1,i);
               y = pVector(2,i);
               
               coll = mathUtilityLight.puntoSuRetta(x1,y1,x2,y2,x,y);
               
               if(coll == 0)
                   return;
               end 
            end
            
        end
        
        %Restituisce 
        % -1 se c a sinistra di a-b
        % 0  se c sulla retta a-b
        % 1  se c a destra di a-b
        function pos = posizionePuntoRispettoALinea(aX, aY, bX, bY, cX, cY)
            
            if(mathUtilityLight.puntoSuRetta(aX,aY,bX,bY,cX,cY));
                pos = 0;
                return;
            end
            
            res = ( (bX-aX) * (cY-aY) - (bY - aY) * (cX - aX));
            
            tol = exp(-6);
            
            if(res > tol)
               pos = -1;
               return;
            end
            
            pos = 1;
            
        end%function posizionePuntoRispettoALinea
        
        %calcola il punto perpendicolare sul primo estremo(A) sul lato sinistro del
        %vettore A(x1,y1) -> B(y1,y2) a distanza 
        function [x4, y4] = calcolaPerpendicolareAlPrimoSide(x1,y1,x2,y2,distanza,side)
            
            N = distanza*2;
            
            dx = x1-x2;
            dy = y1-y2;
            dist = sqrt(dx^2 + dy^2);
            dx = dx/dist;
            dy = dy/dist;
            
            %punto perpendicolare al secondo a sinistra
            x3 = x1 + (N/2) * dy;
            y3 = y1 - (N/2) * dx;
            
            if(strcmp(side,'left'))
                %punto perpendicolare al primo a sinistra
                x4 = x1 + (N/2) * dy;
                y4 = y1 - (N/2) * dx;
            else
                %punto perpendicolare al primo a destra
                x4 = x1 - (N/2) * dy;
                y4 = y1 + (N/2) * dx;
            end
            
        end%function calcolaPerpendicolareAlPrimo
        
        %Intersezione prolungamenti
        %extremityOption
        %false => NON considera intersezione gli estremi se coincidenti
        %true  => considera intersezione estremi concidenti 
        %!!! un qualunque estremo viene comunque considerato intersezione se le due
        %    rette non sono coincidenti
        function [x, y] = lineIntersection(L1_x1, L1_y1,L1_x2,L1_y2,L2_x1,L2_y1,L2_x2,L2_y2,extremityOption)

            A1 = L1_y2 - L1_y1;
            B1 = L1_x1 - L1_x2;
            C1 = (A1 * L1_x1) + (B1 * L1_y1);

            A2 = L2_y2 - L2_y1;
            B2 = L2_x1 - L2_x2;
            C2 = (A2 * L2_x1) + (B2 * L2_y1);

            det = (A1 * B2) - (A2 * B1);
            x = [];
            y = [];
            if (det == 0)%rette parallele
                return;
            else
                x = ((B2 * C1) - (B1 * C2)) / det;
                y = ((A1 * C2) - (A2 * C1)) / det;

                epsilon = exp(-6);

                %Controllo che il punto sia su entrambi i segmenti
                if (...
                    min(L1_x1, L1_x2) - epsilon <= x && x <= max(L1_x1, L1_x2) + epsilon &&...
                    min(L1_y1, L1_y2) - epsilon <= y && y <= max(L1_y1, L1_y2) + epsilon &&...
                    min(L2_x1, L2_x2) - epsilon <= x && x <= max(L2_x1, L2_x2) + epsilon &&...
                    min(L2_y1, L2_y2) - epsilon <= y && y <= max(L2_y1, L2_y2) + epsilon...
                    )
                    if(~extremityOption)
                        %se l'intersezione è uno degli estremi
                        if (...
                            (...%L1 estremo1
                            (L1_x1 - epsilon) <= x && x <= (L1_x1 + epsilon)...
                            &&...
                            (L1_y1 - epsilon) <= y && y <= (L1_y1 + epsilon)...
                            ) ||...
                            (...%L1 estremo2
                            (L1_x2 - epsilon) <= x && x <= (L1_x2 + epsilon)...
                            &&...
                            (L1_y2 - epsilon) <= y && y <= (L1_y2 + epsilon)...
                            )||...
                            (...%L2 -estremo1
                            (L2_x1 - epsilon) <= x && x <= (L2_x1 + epsilon)...
                            &&...
                            (L2_y1 - epsilon) <= y && y <= (L2_y1 + epsilon)...
                            ) ||...
                            (...%L2 - estremo2
                            (L2_x2 - epsilon) <= x && x <= (L2_x2 + epsilon)...
                            &&...
                            (L2_y2 - epsilon) <= y && y <= (L2_y2 + epsilon)...
                            )...
                            )

                            %rette incidenti su uno degli estremi
                            x = [];
                            y = [];
                            return;
                        end
                    end
                end
            end
           
        end%function
        
         %calcola l'angolazione fra due vettori concidenti nel punto x1,y1
        function angolo = calcolaAngolazione(x0, y0, x1, y1, x2, y2)
           
            aX = x1 - x0;
            aY = y1 - y0;
            
            bX = x2 - x1;
            bY = y2 - y1;
            
            collineare = mathUtilityLight.puntoSuRetta(x0, y0, x2, y2, x1, y1);
            
            %gestione del caso in cui l'arco uscente è sovrapposto al
            %corrente ma rivolto nel verso opposto
            if(collineare)
               
                %calcolo il punto perpendicolare a sinistra al primo punto
                %del vettore x0-x1
                [perp_x, perp_y] = mathUtilityLight.calcolaPerpendicolareAlPrimo(x0,y0,x1,y1,10);
                
                pos = mathUtilityLight.posizionePuntoRispettoALinea(x0,y0,perp_x,perp_y,x2,y2);
                
                if(pos == -1)
                   angolo = 180; 
                   return
                end
                angolo = 0;
                return
            end
            
            angolo = mathUtilityLight.AngoloFraDueVettoriCoincidenti(aX,aY,bX,bY);
            
        end%function calcolaAngolazione
       
        %Calcola l'angolazione in valore assoluto fra due vettori applicati
        %nell'origine
        function angolo = AngoloFraDueVettoriCoincidenti(x1, y1, x2, y2)
           
            normA = norm([x1 y1]);
            normB = norm([x2 y2]);
           
            x1 = x1/normA;
            y1 = y1/normA;
            
            x2 = x2/normB;
            y2 = y2/normB;
            
            dotProd = (x1 * x2) + (y1 * y2);
            
            angolo = abs(acos(dotProd)*(180/pi));
            
        end
        
        %calcola il punto perpendicolare sul primo estremo(A) sul lato sinistro del
        %vettore A(x1,y1) -> B(y1,y2) a distanza 
        function [x4, y4] = calcolaPerpendicolareAlPrimo(x1,y1,x2,y2,distanza)
            N = distanza*2;
            
            dx = x1-x2;
            dy = y1-y2;
            dist = sqrt(dx^2 + dy^2);
            dx = dx/dist;
            dy = dy/dist;
            
            %punto perpendicolare al secondo a sinistra
            x3 = x1 + (N/2) * dy;
            y3 = y1 - (N/2) * dx;
            
            %punto perpendicolare al primo a sinistra
            x4 = x1 + (N/2) * dy;
            y4 = y1 - (N/2) * dx;
            
            %punto perpendicolare al primo a destra
%             x4 = x1 - (N/2) * dy;
%             y4 = y1 + (N/2) * dx;
            
        end%function calcolaPerpendicolareAlPrimo
        
        function dist = distanceTwoPoint(aX,aY,bX,bY)
            dist = norm([bX-aX aY-bY]);
        end
        
        function [x , y] = stretchSegment(x1,y1,x2,y2,length,appX, appY)
           
            v = [x2-x1; y2-y1];
            
            vers = v/norm(v);
            
            stretch = vers*length;
            
            x = appX + stretch(1);
            y = appY + stretch(2);
            
        end
        
        
        %compute the distance between AB segment(or not) and point C
        % isSegment = true -> return distance from segment (or extremities)
        % isSegment = false -> return distance from rect passing AB
        function dist = pointLineDistance(aX,aY,bX,bY,cX,cY, isSegment)
            
            dist = mathUtilityLight.crossProduct(aX,aY,bX,bY,cX,cY)/mathUtilityLight.distanceTwoPoint(aX,aY,bX,bY);
            
            if(isSegment)
               
                dot1 = [bX-aX bY-aY]*[cX-bX cY-bY]';
                if(dot1 > 0)
                    dist = mathUtilityLight.distanceTwoPoint(bX,bY,cX,cY);
                    return;
                end
                
                dot2 = [aX-bX aY-bY]*[cX-aX cY-aY]';
                if(dot2 > 0)
                    dist = mathUtilityLight.distanceTwoPoint(aX,aY,cX,cY);
                    return;
                end
            end
            
            dist = abs(dist);
        end
        
        function crossRes = crossProduct(aX,aY,bX,bY,cX,cY)
           
            ab0 = bX - aX;
            ab1 = bY - aY;
            ac0 = cX - aX;
            ac1 = cY - aY;
            
            crossRes = ab0*ac1-ab1*ac0;
        end
        
    end%Static methods
    
end

