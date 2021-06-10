function varargout=adjustAxes(handles4timeaxis)
% Variation of original adjustAxes function, used for ensuring timeaxis_ucsd function works on zooming & panning.
%
% This version allows axes handles to be specified explictly.
%
% INPUT:
% handles4timeaxis - handle of axis we want to modify. Default is to apply to all axss
% handles within current figure
%
% OUTPUT:
% handles that have been modified
%
% EXAMPLE:
% t=now+(1:1000)/24;
% ax1=subplot(2,1,1);
% plot(t,sin(t),'Color','g');
% ax2=subplot(2,1,2);
% plot(t,sqrt(t),'Color','r');
% linkaxes([ax1 ax2],'x');
% adjustAxes(); % use default handles - all subplots
% %adjustAxes([ax1,ax2]); % as above, but handles specified explictly
% %adjustAxes(ax2); % only apply to second handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $Workfile:   adjustAxes.m  $
% $Revision:   1.1  $
% $Author:   ted.schlicke  $
% $Date:   May 16 2016 11:31:00  $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0 % didn't pass this function any axes handles?
    % then apply timeaxis function to all axes.
    h=get(0,'CurrentFigure');
    handles4timeaxis = findobj(h,'type','axes','-not','Tag','legend','-not','Tag','Colorbar'); % handles for axes
end

% Note: we can define callback function different ways:
%
% 1) as a string. For example:
%   set(zoom,'ActionPostCallback','arrayfun(@timeaxis_ucsd,handles4timeaxis,''UniformOutput'',0);'); % adjust axes if we zoom
% But for this to work, the axis handle variable 'handles4timeaxis' has to be defined in the base workspace:
%   assignin('base','handles4timeaxis',handles4timeaxis)
% This is a bit messy and can cause issues (e.g. if variable is deleted elsewhere)
%
% 2) as a function handle. This is what we do here- we define a separate function
% within this function, which is called with the required axis handles directly.
% No need for global variables!

% Our callback function -
    function adjustAxesCallbackFunction(~,~,handles4timeaxis) % don't need first 2 arguments which are automatically generated by matlab)
        arrayfun(@timeaxis_ucsd,handles4timeaxis,'UniformOutput',false); % apply timeaxis function to all axis handles passed to function
    end

adjustAxesCallbackFunction([],[],handles4timeaxis); % sort time axis straight away.
set(zoom,'ActionPostCallback',{@adjustAxesCallbackFunction,handles4timeaxis}) % adjust axes if we zoom
set(pan,'ActionPostCallback',{@adjustAxesCallbackFunction,handles4timeaxis}); % adjust axes if we pan

% If user requested an output from this function, provide handles
if nargout>0
    varargout{1}=handles4timeaxis;
end
if nargout>1
    error('Too many outputs requested!')
end
end
