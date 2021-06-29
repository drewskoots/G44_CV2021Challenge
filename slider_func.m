function slider_func(app, ax,image_right,image_left)



image_right = imresize(image_right, size(image_left, [1 2])); % making the dimensions equal


isBtnPressed = false;
cir_radius = 50;
cir_angles = linspace(0,2*pi,50);
[cir_x, cir_y] = pol2cart(cir_angles, cir_radius);
cir_y = cir_y + size(image_left,1)/2;
f = figure();
ax = axes('Units', 'pixels');
imshow(image_left);
hold(ax);
im_handle = imshow(image_right);
im_handle.AlphaData = zeros(size(image_left, [1 2]));
patch_handle = patch(cir_x, cir_y, 'k', ...
    'EdgeColor', 'w', ...
    'FaceAlpha', 0.5, 'LineWidth',1);
axes_pos = cumsum(ax.Position([1 3]));
f.WindowButtonMotionFcn = {@cb_motion,  size(image_left,2), im_handle, cir_x, patch_handle, axes_pos};
f.WindowButtonDownFcn = @cb_btnPressed
f.WindowButtonUpFcn = @cb_btnReleased
function cb_motion(obj, ~, im_width, im_handle, cir_x, patch_handle, axes_pos)
    
    if isBtnPressed
        x_pos = obj.CurrentPoint(1);
        if x_pos > axes_pos(1) && x_pos < axes_pos(2)
            left_cols = floor(floor(x_pos - axes_pos(1))/diff(axes_pos) * im_width);
            im_handle.AlphaData(:, 1:left_cols) = 0;
            im_handle.AlphaData(:, left_cols+1:end) = 1;
            patch_handle.Vertices(:,1) = cir_x' + left_cols;
        end
    end
end
function cb_btnPressed(~,~)
    isBtnPressed = true;
end
function cb_btnReleased(~,~)
    isBtnPressed = false;
end

end


