function [] = coronary_refine(rpath)
% This function processes each probability map of coronary arteries under
% 'rpath'. The processing steps include but not limited to thresholding, 
% filling holes, thinning, detecting bifurcation or end points, 
% reconnecting disconnected branches, removing isolated branches, and 
% obtains a coronary artery tree finally.
% 
% Examples:
%   coronary_refine('path_of_parent_directory_containg_volumes')

% create output directory
close all;
wpath = fullfile(rpath, 'coronary');
if ~exist(wpath, 'dir'), mkdir(wpath); end

% processing each volume under rpath
img_list = dir(fullfile(rpath, '*.mha'));
for i = 1:length(img_list)
    %% read mha volume
	disp('read mha volume');
	tic
    img_path = fullfile(rpath, img_list(i).name);
    [img_prop, ~] = mha_read_volume(img_path);
	toc

    %% thresholdingCoro
    % check the binary image obtained by considering it as a volume data,
    % and you can also store the binary volume into a single file (.mha file)
	disp('thresholdingCoro');
	tic
    img_bin = img_prop >= (0.5 * intmax('uint16'));
	toc

    %% filling holes
	disp('filling holes');
	tic
	SE = strel('sphere', 6);
    img_fill = imclose(img_bin, SE);
	toc

	link3d(img_bin, img_fill);
	set(gcf, 'name', 'bin and fill');

	%% thinning
    % plot the centerline of coronary artery by considering it as a set of
    % points, e.g. denote 'img_thin' as the result of thinning step
	disp('thinning');
	tic
	img_thin = bwskel(img_fill);
	img_thin = bwmorph3(img_thin, 'clean');
	toc
	link3d(img_fill, img_thin);
	set(gcf, 'name', 'fill and thin');

    %% detecting bifucation and end points
	disp('detecting bifucation and end points')
	tic
	img_endPoints = bwmorph3(img_thin, 'endpoint');
	img_bifucation = bwmorph3(img_thin, 'branchpoints');
	toc
	img_bi_origin = img_bifucation;
	link3d(img_thin, img_endPoints);
	set(gcf, 'name', 'thin and end points');
	link3d(img_thin, img_bifucation);
	set(gcf, 'name', 'thin and bifucation');

    %% reconnecting disconnected branches & removing isolate points or branches
	disp('connect disconnected branches');
	tic
	img_connect = img_thin;
	while true
		img_endPoints = bwmorph3(img_connect, 'endpoint');
		[img_labeled, ~] = bwlabeln(img_connect);

		[endPointListX, endPointListY, endPointListZ] = ...
			ind2sub(size(img_endPoints), find(img_endPoints));
		endPointListLen = length(endPointListX);
		img_endPoints_labeled = zeros(size(img_endPoints));
		img_endPoints_labeled(img_endPoints) = img_labeled(img_endPoints);
		mindis = [];
		for ii = 1 : endPointListLen
			x = endPointListX(ii);
			y = endPointListY(ii);
			z = endPointListZ(ii);
			label = img_labeled(x, y, z);
			difflabel = (img_endPoints_labeled ~= label & ...
				img_endPoints_labeled ~= 0);
			[xx, yy, zz] = ind2sub(size(difflabel),	find(difflabel));
			locations = [xx, yy, zz];
			distance = (locations - [x, y, z]).^2;
			distance = distance(:, 1, :) + distance(:, 2, :) ...
				+ distance(:, 3, :);
			nearest = locations(distance == min(distance), :);
			if(min(distance) < 1500)
				mindis = [min(distance), [x, y, z], nearest; mindis];
			end
		end

		if isempty(mindis)
			break;
		else
			disp(['min distance: ', num2str(min(mindis(:, 1)))]);
			id = find(mindis(:, 1) == min(mindis(:, 1)));
			img_connect = add_line_discrete(img_connect, ...
				mindis(id(1), 2:4), mindis(id(1), 5:7));
		end
	end
	toc

	disp('remove isolate points');
	tic
	[img_labeled, n] = bwlabeln(img_connect);

	% remove isolate branches
	for ii = 1:n
		labeled_ii = img_labeled == ii;
		branchLen = sum(labeled_ii(:) ~= 0);
		if branchLen < 10
			disp(['delete branch len: ', num2str(branchLen)]);
			img_connect(labeled_ii) = 0;
		end
	end

	% remove short branches
	flag = true;
	while flag
		flag = false;
		img_bifucation = bwmorph3(img_connect, 'branchpoints');
		[img_labeled, n] = bwlabeln(img_connect - img_bifucation);
		for ii = 1:n
			labeled_ii = img_labeled == ii;
			branchLen = sum(labeled_ii(:) ~= 0);
			if branchLen < 5
				disp(['delete branch len: ', num2str(branchLen)]);
				img_connect(labeled_ii) = 0;
				flag = true;
			end
		end
	end
	toc

	figure;
	ax1=subplot(1,2,1);show3(img_thin);

	[img_labeled, n] = bwlabeln(img_connect);
	color_trip = jet(n);
	ax2=subplot(1,2,2);
	for ii = 1:n
		[cpt_x, cpt_y, cpt_z] = ind2sub(size(img_labeled == ii), ...
			find(img_labeled == ii));
		plot3(cpt_x, cpt_y, cpt_z, ...
			'.', 'Color', color_trip(ii, :));
		hold on;
	end

	Link = linkprop([ax1, ax2],{'CameraUpVector', 'CameraPosition',...
		'CameraTarget', 'XLim', 'YLim', 'ZLim'});
	setappdata(gcf, 'StoreTheLink', Link);
	set(gcf, 'name', 'thin and connected branches');

    %% obtain coronary artery tree (by tracking or other methods)
    % plot the complete coronary artery tree in different color according 
    % to the ids of branches, e.g. denote 'coro_tree', a cell array, as the 
    % coronary artery tree obtained, and each element is a coordinate array
    % of a single branch
	figure;
	img_bifucation = bwmorph3(img_connect, 'branchpoints');
	[img_labeled, n] = bwlabeln(img_connect - img_bifucation);
	color_trip = jet(n);
	ax1 = subplot(1, 2, 1);
	for ii = 1:n
		[cpt_x, cpt_y, cpt_z] = ind2sub(size(img_labeled == ii), ...
			find(img_labeled == ii));
		plot3(cpt_x, cpt_y, cpt_z, ...
			'.', 'Color', color_trip(ii, :));
		hold on;
	end

	branchPoints = get_branch_points(img_bi_origin);
	coro_tree = track_branches(img_connect - img_bifucation, branchPoints);
    ax2 = subplot(1, 2, 2); coronary_show(coro_tree);
	Link = linkprop([ax1, ax2],{'CameraUpVector', 'CameraPosition',...
		'CameraTarget', 'XLim', 'YLim', 'ZLim'});
	setappdata(gcf, 'StoreTheLink', Link);
	set(gcf, 'name', 'branch points and line');

    %% save the tree obtained into a mat file (.mat)
    tree_name = split(img_list(i).name, '.');
    tree_name = [tree_name{1}, '.mat'];
    tree_path = fullfile(wpath, tree_name);
    save(tree_path, 'coro_tree');
end

end

function show3(img, style)
	if ~exist('style','var')
		style = '.r';
	end
    [cpt_x, cpt_y, cpt_z] = ind2sub(size(img), find(img));
    plot3(cpt_x, cpt_y, cpt_z, style);
end

function link3d(img1, img2)
	figure;
	ax1=subplot(1,2,1);show3(img1);
	ax2=subplot(1,2,2);show3(img2);
	Link = linkprop([ax1, ax2],{'CameraUpVector', 'CameraPosition',...
		'CameraTarget', 'XLim', 'YLim', 'ZLim'});
	setappdata(gcf, 'StoreTheLink', Link);
end

function result = add_line_discrete(img, P1, P2)
	result = img;
	len = max(abs(P1 - P2));
	x = P1(1): (P2(1) - P1(1))/len : P2(1);
	y = P1(2): (P2(2) - P1(2))/len : P2(2);
	z = P1(3): (P2(3) - P1(3))/len : P2(3);
	if isempty(x)
		x = ones(1, len + 1) * P1(1); 
	end
	if isempty(y)
		y = ones(1, len + 1) * P1(2); 
	end
	if isempty(z)
		z = ones(1, len + 1) * P1(3); 
	end
	p = uint16([x; y; z]);
	result(sub2ind(size(result), p(1, :) ,p(2, :), p(3, :))) = 1;
end

function coro_tree = track_branches(img, branchPoints)
branchPoints = double(branchPoints);
[img_labeled, n] = bwlabeln(img);
coro_tree = cell(n, 1);
for ii = 1:n
	points = [];
	branch = img_labeled == ii;
	branch = padarray(branch,[1, 1, 1], 0, 'both');
	len = sum(branch(:) ~= 0);
	endpoints = bwmorph3(branch, 'endpoint');
	[trackx, tracky, trackz] = ind2sub(size(endpoints), ...
		find(endpoints ~= 0));
	[trackx, tracky, trackz] = deal(trackx(1), tracky(1), trackz(1));

	% add branchpoint to branches
	distance = (branchPoints - [trackx, tracky, trackz]).^2;
	distance = distance(:, 1, :) + distance(:, 2, :) ...
		+ distance(:, 3, :);
	if(min(distance) < 16)
		points = branchPoints(distance == min(distance), :);
	end

	for iii = 1:len
		neighbor = branch(trackx - 1 : trackx + 1, ...
			tracky - 1 : tracky + 1, ...
			trackz - 1 : trackz + 1);
		neighbor(2, 2, 2) = 0;
		if sum(neighbor(:)) == 0
			break;
		end
		[shiftx, shifty, shiftz] = ...
			ind2sub(size(neighbor), find(neighbor ~= 0));
		[shiftx, shifty, shiftz] = ...
			deal(shiftx(1), shifty(1), shiftz(1));
		nextpoint = [trackx, tracky, trackz] - [2, 2, 2] ...
			+ [shiftx, shifty, shiftz];
		branch(trackx, tracky, trackz) = 0;
		points = [points; trackx - 1, tracky - 1, trackz - 1];
		[trackx, tracky, trackz] = deal(nextpoint(1), nextpoint(2), ...
			nextpoint(3));
	end
	points = [points; nextpoint(1) - 1, nextpoint(2) - 1, ...
		nextpoint(3)- 1];
	% add branchpoint to branches
	distance = (branchPoints - nextpoint).^2;
	distance = distance(:, 1, :) + distance(:, 2, :) ...
		+ distance(:, 3, :);
	if(min(distance) < 16)
		points = [points; branchPoints(distance == min(distance), :)];
	end
	coro_tree{ii, 1} = points;
end
end

function branchPoints = get_branch_points(img_bifucation)
[img_bi_labeled, n] = bwlabeln(img_bifucation);
branchPoints = zeros(n, 3);
for ii = 1:n
	[cpt_x, cpt_y, cpt_z] = ind2sub(size(img_bi_labeled == ii), ...
		find(img_bi_labeled == ii));
	[cpt_x, cpt_y, cpt_z] = deal(mean(cpt_x), mean(cpt_y), mean(cpt_z));

	branchPoints(ii, :) = [cpt_x, cpt_y, cpt_z];
end
branchPoints = uint16(branchPoints);
end
