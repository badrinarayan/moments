classdef Linearize < handle
  properties (SetAccess = private)
    ranges
    num_ranges
    lengths
  end
  methods
    function L = Linearize(varargin)
        L.ranges = varargin;
        L.num_ranges = length(L.ranges);
        L.lengths = cellfun(@length,L.ranges);
    end
    function i = index(L,varargin)
      vals = varargin;
      i = 0;
      for k = L.num_ranges:-1:1
        Lk = L.ranges{k};
        i = i + find(Lk==vals{k},1,'first') - 1;
        if k~=1
          i = i*L.lengths(k-1);
        end
      end
      i = i + 1;
    end
    function varargout = values(L,i)
      i = i - 1;
      for k=1:length(L.ranges)
        Lk = L.ranges{k};
        ik = mod(i,L.lengths(k));
        varargout{k} = Lk(ik+1);
        i = i - ik;
        i = i/length(L.ranges{k});
      end
    end
  end
end