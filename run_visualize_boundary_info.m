addpath('/home/twang/software/superpixels64');

Consts;
Params;

params.overwrite = false;
params.seg.featureSet = consts.BFT_RGBD;

% note: change this for appropriate visualization subplots
vis_row = 2;
vis_col = 3;

set(0,'DefaultFigureVisible','off');

for ii = 1 : consts.numImages
    
    fprintf('Visualizing (Image %d/%d).\r', ...
        ii, consts.numImages);

    if ~consts.useImages(ii)
      continue;
    end
    
    outFilename = sprintf(consts.boundaryVisualizeFileName, ...
        params.seg.featureSet, params.seg.numStages, ii);
    
    if ~exist(outFilename, 'file') || params.overwrite
    
        h = figure;

        % load rgb image (for overlay)
        load(sprintf(consts.imageRgbFilename, ii));

        % load depth (for visualize only)
        load(sprintf(consts.imageDepthFilename, ii));
        subplot(vis_row,vis_col,1);
        imagesc(imgDepth); axis equal; axis off;

        % load boundary info file
        for stage = 1 : params.seg.numStages;

            if stage == 1
              boundaryInfoFilename = sprintf(consts.watershedFilename, ii);
            else
              boundaryInfoFilename = sprintf(consts.boundaryInfoPostMerge, ...
                  params.seg.featureSet, stage, ii);
            end

            load(boundaryInfoFilename, 'boundaryInfo');

            segs = boundaryInfo.imgRegions;

            im_segs = segImage(im2double(imgRgb), double(segs));
            subplot(vis_row,vis_col,stage+1);
            imagesc(im_segs); axis equal; axis off;

        end
        print(h,'-dpng', outFilename);
    
    end
    
end

set(0,'DefaultFigureVisible','on');