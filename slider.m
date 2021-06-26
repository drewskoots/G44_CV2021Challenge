image_left = im2double(imread('pears.png')); % opening two example images
image_right = rgb2gray(imread('pears.png'));



image_right = imresize(image_right, size(image_left, [1 2])); % making the dimensions equal

f = figure();
 ax = axes('Units', 'pixels');
imagesc(ax,image_left);
hold(ax);
im_handle = imagesc(ax,image_right);
im_handle.AlphaData = zeros(size(image_left, [1 2]));

axes_pos = cumsum(ax.Position([1 3]));
f.WindowButtonMotionFcn = {@cb,  size(image_left,2), im_handle, axes_pos};
pause(0.1);


function cb(obj, ~, im_width, im_handle, axes_pos)
    x_pos = obj.CurrentPoint(1);
    if x_pos > axes_pos(1) && x_pos < axes_pos(2)
        left_cols = floor(floor(x_pos - axes_pos(1))/diff(axes_pos) * im_width);
        im_handle.AlphaData(:, 1:left_cols) = 0;
        im_handle.AlphaData(:, left_cols+1:end) = 1;       
        xline(left_cols,'w','LineWidth',2);
        pl = left_cols;
        if pl~= left_cols
            clear xline
        end
    end
end

