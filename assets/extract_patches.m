function D = read_disparities(filename)
  % loads disparity map D from png file

  I = imread(filename);
  D = double(I)/256;
  D(I==0) = -1;
end

function [patches_data] = extract_patches(
  images_dir, images_ids, half_patch_size, half_disparity_range
)
num_available_values = 0

for i = 1:length(image_ids)
  id = images_ids[i];

  filename = sprintf('%s/disp_noc_0/%06d_10.png', images_dir, id);
  disparity_map = read_disparities(fn);
  num_available_values = num_available_values ...
                         + sum(disparity_map(:)~=-1);
end

patches_data = zeros(4, length(images_ids))

for i = 1:length(image_ids)
  id = images_ids[i];

  filename = sprintf('%s/disp_noc_0/%06d_10.png', images_dir, id);
  disparity_map = read_disparities(fn);
  [row, col] = find(disparity_map~=-1);
  [height, width] = size(disparity_map);

  for pixel_index = 1:length(row)
    left_patch_center_x = col(pixel_index);
    left_patch_center_y = row(pixel_index);

    disparity = disparity_map(
      left_patch_center_x, left_patch_center_y
    );

    right_patch_center_x = round(left_patch_center_x - disparity);
    right_patch_center_y = left_patch_center_y;

    left_patch_fits = ...
      left_patch_center_x + half_patch_size <= width ...
      && left_patch_center_x - half_patch_size > 0  ...
      && left_patch_center_y + half_patch_size <= height ...
      && left_patch_center_y - half_patch_size > 0;

    half_right_patch_size = half_disparity_range + half_patch_size;
    right_patch_fits = ...
      right_patch_center_x - half_right_patch_size > 0 ...
      && right_patch_center_x + half_right_patch_size <= width ...
      && right_patch_center_y - half_patch_size > 0 ...
      && right_patch_center_y + half_patch_size <= height;

    if ll && rr_type1
      patches_data(:,i) = [
        id; left_patch_center_x;
        left_patch_center_y; right_patch_center_x
      ];
    end
  end
end
