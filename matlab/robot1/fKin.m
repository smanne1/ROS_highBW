function [v,omega] = fKin(wr,wl)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
dw = 0.325;
R = 0.038;
v = (wr + wl)*R/2;
omega = (wr - wl)*R/dw;
end

