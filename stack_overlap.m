function [scan]=stack_overlap(scan,stack1,stack2)
%Find overlapping slice ranges in stack1&2

%Stack1
scan.(stack1).overlapFirst = scan.(stack1).overlapMatch - ...
    scan.(stack2).overlapMatch + scan.(stack2).sliceFirst;
scan.(stack1).overlapLast = scan.(stack1).sliceLast;
%Stack2
scan.(stack2).overlapFirst = scan.(stack2).sliceFirst;
scan.(stack2).overlapLast = scan.(stack1).sliceLast - ...
    scan.(stack1).overlapMatch + scan.(stack2).overlapMatch;
end