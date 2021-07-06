im_left = im2double(imread('Datasets\Kuwait\2015_02.jpg')); % opening two example images
im_right = im2double(imread('Datasets\Kuwait\2018_06.jpg'));

im_right = imresize(im_right, size(im_left, [1 2])); % making the dimensions equal
midx = size(im_right,2)/2;
midy = size(im_right,1)/2;
global isBtnPressed
isBtnPressed = false;

f = figure();
ax = axes('Units', 'pixels');
imshow(im_left);
hold(ax);
im_handle = imshow(im_right);
im_handle.AlphaData = zeros(size(im_left, [1 2]));

axes_pos = cumsum(ax.Position([1 3]));
f.WindowButtonMotionFcn = {@cb_motion,  size(im_left,2), im_handle, axes_pos};
f.WindowButtonDownFcn = @cb_btnPressed;
f.WindowButtonUpFcn = @cb_btnReleased;
im_handle.AlphaData(:, 1:midx) = 0;
im_handle.AlphaData(:, midx:end) = 1;
h = images.roi.Line(gca,'Position',[midx 0; midx 2*midy],'Color','w','LineWidth',3);
function cb_motion(obj, ~, im_width, im_handle, axes_pos)


global isBtnPressed    
    if isBtnPressed
        x_pos = obj.CurrentPoint(1,1);
        if x_pos > axes_pos(1) && x_pos < axes_pos(2) 
            left_cols = floor(floor(x_pos - axes_pos(1))/diff(axes_pos) * im_width);
            im_handle.AlphaData(:, 1:left_cols) = 0;
            im_handle.AlphaData(:, left_cols+1:end) = 1;

        end
    end
end
function cb_btnPressed(~,~)
    global isBtnPressed
    isBtnPressed = true;
end
function cb_btnReleased(~,~)
    global isBtnPressed
    isBtnPressed = false;
end



% function slider_func(app, ax, image_right, image_left)
%             image_right = imresize(image_right, size(image_left, [1 2])); % making the dimensions equal
%             midx = size(image_right,2)/2
%             midy = size(image_right,1)/2;
%             ax.Units='Pixels';
%             imagesc(ax,image_left);
%             hold(ax,'on');
%             im_handle = imagesc(ax,image_right);
%             im_handle.AlphaData = zeros(size(image_left, [1 2]));
%             axes_pos = cumsum(ax.Position([1 3]));
%             x = app.SliderChanging;
%             x_pos = (midx*x)/100;
%             left_cols = floor(floor(x_pos - axes_pos(1))/diff(axes_pos)*2*midx);
%             im_handle.AlphaData(:, 1:left_cols) = 0;
%             im_handle.AlphaData(:, left_cols+1:end) = 1;
%         end