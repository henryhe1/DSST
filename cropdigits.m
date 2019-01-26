% This program crops the input boxes of the DSST based on the template of
% the wechsler adult intelligence scale. The algorithm uses Blob Analysis
% to obtain the centroids of the 4 square anchor points on the DSST, then
% uses relative distances to locate the text boxes of interest. 
% Inputs are a scan of the completed DSST saved as an image file (filepath), and a patient ID (text).
% TODO: deal with cases where the anchors aren't necessarily the largest
% blobs at different resolutions.

% image = path to image file of scanned DSST 
% patientID = unique identifier as text

function cropdigits(image, patientID)

    % init
    image = imread(image);
%     patientID = 'patient2';
    direc = patientID;

    BW = im2bw(image);
    BW = imcomplement(BW);
    imshow(BW);
    CC = bwconncomp(BW);

    hblob = vision.BlobAnalysis;
    hblob.CentroidOutputPort = true;
    hblob.MaximumCount = 3500;
    hblob.Connectivity = 4;
    hblob.MaximumBlobArea = 12000;
    hblob.MinimumBlobArea = 9000;
    hblob.LabelMatrixOutputPort = true;
    hblob.OrientationOutputPort = true;
    hblob.MajorAxisLengthOutputPort = true;
    hblob.MinorAxisLengthOutputPort = true;
    hblob.EccentricityOutputPort = true;
    hblob.ExtentOutputPort = true;
    hblob.BoundingBoxOutputPort = true;
    hblob.PerimeterOutputPort = true;
    [AREA,CENTROID,BBOX,MAJOR,MINOR,ORIENT,ECCEN,EXTENT,PERIMETER, LABEL] = step(hblob,BW);
    figure
    imshow(LABEL*2^16)
    numberOfBlobs = length(AREA);

    %get largest 4 centroids (after the first one)
    [~, idx] = sort(AREA, 'descend');
    % AREA = sort(AREA,'descend');

    idx = idx(1:4);
%     newCentroid = [];
    newCentroid = zeros(4,2);
%     for i=1:length(idx)
%        if ( (4*MAJOR(idx(i))) > (0.7*PERIMETER(idx(i)))) && ((4*MAJOR(idx(i))) < (1.3*PERIMETER(idx(i))))
%             newCentroid(end+1,:) = CENTROID(idx(i),:);
%        end
%     end
% 


    % idx(2:5) are the indices of the four square centroids
    % 
    for i=1:4
        newCentroid(i,:) = CENTROID(idx(i),:);
    end


    % Dist btween vert anchors = 571.975
    % Dist between horz anchors = 760.075
    % First Row Top: (22,198) = 34
    % First Row Bottom: (22, 232) 
    % Second Row Top: (22, 296)
    % Second Row Bottom: (22, 328) = 32
    % Thrid Row Top/Bottom 398, 430 =32
    % Fourth Row Top/Bottom 498, 529 =31
    % Rows left and right (xcoord): 50, 745

    leftborder = min(newCentroid(:,1));
    topborder = min(newCentroid(:,2));
    rightborder = max(newCentroid(:,1));
    bottomborder = max(newCentroid(:,2));

    height = bottomborder - topborder;
    width = rightborder - leftborder;

    % relative location of first column = (198-18)/height = (198-18)/572
    relativeFirstRowY = ((198-18)/572 * height) + topborder;
    % 18/X = 0.36 = 18/50 
    % X = 18/0.36  /// (50-18)/width

    % /// 423, 259 (anchor)
    relativeFirstRowX = leftborder + (((50-18)/760) * width);

    %relative height of box = 32/572
    relativeBoxHeight = (32/572) * height;
    %relative width of box = 28/760
    relativeBoxWidth = (27.8/760.0751) * width;
    %relative height between rows
    relativeRowBetween = (68/572) * height;

    mkdir(direc)
    counter = 1;
    for j = 1:4

        Ylocation = relativeFirstRowY + ((relativeBoxHeight + relativeRowBetween)*(j-1));

        for i = 1:25
           I2 = imcrop(image, [relativeFirstRowX+((i-1)*relativeBoxWidth), Ylocation, relativeBoxWidth, relativeBoxHeight]);
           savename = strcat(direc, '/', patientID, '-', num2str(counter), '.png');
           imwrite(I2, savename);
           counter = counter + 1;

        end
    end


    % 
    % centroid = hblob(BW);
    % 
    % for i=1:5
    %     BW(centroid(i,1), centroid(i,2)) = 0;
    % end
    % figure
    % imshow(BW);





    % 
    % 
    % % largest connected pixels
    % numPixels = cellfun(@numel,CC.PixelIdxList);
    % [biggest,idx] = max(numPixels);
    % 
    % % second biggest
    % [second, idx2] = 
    % 
    % BW(CC.PixelIdxList{idx}) = 0;
    % 
    % figure;
    % imshow(bw)

end