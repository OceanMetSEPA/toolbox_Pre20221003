function [ ] = dispStruct(s,rows2Display)
% Display struct (array)
%
% This function displays a struct whose fields have equal length to the
% screen for viewing
%
% INPUT:
% s - struct to display
%
% Optional Inputs:
% rows2Display - indices of rows to display
%
% OUTPUT:
% none
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $Workfile:   dispStruct.m  $
% $Revision:   1.2  $
% $Author:   Ted.Schlicke  $
% $Date:   Nov 20 2020 09:16:10  $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0
    help dispStruct
    return
end

if ~isstruct(s)
    error('Argument 1 should be struct')
end

% Check field sizes
fn=fieldnames(s);
if length(s)==1 % struct, not struct array
    try
        s=struct2struct(s); % Convert to struct array
    catch err
        disp(err)
        error('Problem converting to struct array')
    end
else
    % it's a struct array, so should be fine
end

% Do we want to filter rows?
if nargin>1
    if islogical(rows2Display)
        rows2Display=find(rows2Display);
    end
    if ~isnumeric(rows2Display)
        error('Argument 2 should be numeric')
    end
    if any(rows2Display~=floor(rows2Display))
        error('Argument 2 should be integer')
    end
    if any(rows2Display<1 | rows2Display>length(s))
        error('Rows should be between 1 and %d',length(s))
    end
    s=s(rows2Display);
end

c=struct2cell(s)';

% Prepare cell array for display
fn=ungenvarname(fn'); %
op=[fn;c];
disp(op);


end
