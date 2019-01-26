# DSST Preprocessing

% This program crops the input boxes of the DSST based on the template of
% the wechsler adult intelligence scale. The algorithm uses Blob Analysis
% to obtain the centroids of the 4 square anchor points on the DSST, then
% uses relative distances to locate the text boxes of interest. 
% Inputs are a scan of the completed DSST saved as an image file (filepath), and a patient ID (text).
% TODO: deal with cases where the anchors aren't necessarily the largest
% blobs at different resolutions.

% image = path to image file of scanned DSST 
% patientID = unique identifier as text
