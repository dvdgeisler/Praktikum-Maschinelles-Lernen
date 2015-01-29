function [ n ] = test( varargin )
if ischar(varargin{1})
  n = struct;
  return
end

% Apply
if iscell(varargin{1})
  n = netsum.apply(varargin{:});
else
  n = netsum.apply(varargin,1,1);
end

