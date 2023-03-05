function colorAutoCorrelogram = colorAutoCorrelogram(image)
% input: image in uint8 form, from wich to extract the color auto correlogram
% output: 1x64 feature vector containing the color auto correlogram

% quantize image into 64 colors = 4x4x4, in RGB space
[img_no_dither, map] = rgb2ind(image, 64, 'nodither');
% figure, imshow(img_no_dither, map);

%rgb = ind2rgb(img_no_dither, map); % rgb = double(rgb)
% imshow(rgb);
% rgb = cat(3, r, g, b);

% clear workspace
%clear('img_no_dither');

% 4 predefined distances between
% neighbor pixel intensities
% according to "Image Indexing Using Color Correlograms" paper
distances = [1 3 5 7];

colorAutoCorrelogram = correlogram(img_no_dither, distances, length(map));
% colorAutoCorrelogram = reshape(colorAutoCorrelogram, [4 4 4]);
% 
% % consturct final correlogram using distances
% colorAutoCorrelogram(:, :, 1) = colorAutoCorrelogram(:, :, 1)*distances(1);
% colorAutoCorrelogram(:, :, 2) = colorAutoCorrelogram(:, :, 2)*distances(2);
% colorAutoCorrelogram(:, :, 3) = colorAutoCorrelogram(:, :, 3)*distances(3);
% colorAutoCorrelogram(:, :, 4) = colorAutoCorrelogram(:, :, 4)*distances(4);

% reform it to vector format
%colorAutoCorrelogram = reshape(colorAutoCorrelogram, 1, 64*4);

end

% check if point is a valid pixel
function valid = is_valid(X, Y, point)
    valid = 1;
    if point(1) < 0 || point(1) >= X || point(2) < 0 || point(2) >= Y
        valid = 0;
    end
end

% % find pixel neighbors
% function Cn = get_neighbors(X, Y, x, y, dist)
%     cn1 = [x+dist, y+dist];
%     cn2 = [x+dist, y];
%     cn3 = [x+dist, y-dist];
%     cn4 = [x, y-dist];
%     cn5 = [x-dist, y-dist];
%     cn6 = [x-dist, y];
%     cn7 = [x-dist, y+dist];
%     cn8 = [x, y+dist];
%  
%     points = {cn1, cn2, cn3, cn4, cn5, cn6, cn7, cn8};
%     Cn = cell(1, length(points));
%  
%     for ii = 1:length(points)
%         valid = is_valid(X, Y, points{1, ii});
%         if (valid)
%         Cn{1, ii} = points{1, ii};
%         end
%     end
% %    Cn = {cn1, cn2, cn3, cn4, cn5, cn6, cn7, cn8};
% end
%  
% % get correlogram
% function colors_percent = correlogram(photo, Cm, K)
%     [X, Y, ~] = size(photo);
%     colors_percent = [];
%     for k = 1:K
%         countColor = 0;
%  
%         color = zeros(1, length(Cm));
%  
%         for x = 2:floor(X/10):X
%            for y = 2:floor(Y/10):Y
%                Ci = photo(x, y);
%                Cn = get_neighbors(X, Y, x, y, k);
%  
%                for jj = 1:length(Cn)
%               
%                    Cj = photo( Cn{1, jj}(1), Cn{1, jj}(2) );
% 
%                    for m = 1:length(Cm)
%                        if isequal(Cm(m), Ci) && isequal(Cm(m), Cj)
%                            countColor = countColor + 1;
%                            color(m) = color(m) + 1;
%                        end
%                    end
%               
%                end
%            end
%         end
%  
%         for ii = 1:length(color)
%             color(ii) = double( color(ii) / countColor );
%         end
%  
%         colors_percent = color;
%     end
% end

% find pixel neighbors
function Cn = get_neighbors(x, y, dist)
    cn1 = [x+dist, y+dist];
    cn2 = [x+dist, y];
    cn3 = [x+dist, y-dist];
    cn4 = [x, y-dist];
    cn5 = [x-dist, y-dist];
    cn6 = [x-dist, y];
    cn7 = [x-dist, y+dist];
    cn8 = [x, y+dist];
 
    Cn = {cn1, cn2, cn3, cn4, cn5, cn6, cn7, cn8};
end

% above implementation does not compute for all lags below I have tried for
% all lags but photo(5, -1) is getting accessed which is an error need to
% look into it.
% by lags i mean all values of K. in the above implementation only lag 1
% occurs because for k = 1:K will only iterate once.

function colors_percent = correlogram(photo, K, num_of_colors)
    [X, Y, ~] = size(photo);
    colors_percent = zeros(length(K), num_of_colors);
    index = 1;
    for k = K
        countColor = 0;
        color = zeros(1, num_of_colors);
 
        for x = 2:floor(X/10):X
           for y = 2:floor(Y/10):Y
               Ci = photo(x, y);
               Cn = get_neighbors(x, y, k);
 
               for jj = 1:length(Cn)
                   if(is_valid(X, Y, Cn{1, jj}) == 1)
                       Cj = photo( Cn{1, jj}(1), Cn{1, jj}(2) );
                 
                       if isequal(Ci, Cj)
                           countColor = countColor + 1;
                           color(Ci + 1) = color(Ci + 1) + 1;
                       end
                 
                   end
               end
           end
        end
 
        for ii = 1:length(color)
            color(ii) = double( color(ii) / countColor ) * k;
        end
 
        colors_percent(index, : ) = color;
        index = index + 1;
    end
end
