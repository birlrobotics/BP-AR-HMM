%@Hongmin Wu
%Friday, April 7, 2017
%function: for modifying the mean of original data to 0
%                        the covariance of original data to 1 (Unit Matrix)
%INPUT: original data
%OUTPUT: preprocessing data
function [cellData, meanSigma] = data_preprocessing(cellData)
%% the smoothing method by Scott Niekum
    %Smooth trajextory
for nSeq = 1:length(cellData)
    sensor = cellData{nSeq};
    radius = 10;
    [dims,len] = size(sensor);
    smoothed = zeros(dims,len);
    for j=1:dims
         for k=1:len
             low = max(1,k-radius);
             high = min(len,k+radius);
             smoothed(j,k) = mean(sensor(j,low:high));
         end
    end
     sensor = smoothed;
    %Adjust each dim to mean 0   
    mY = mean((sensor'));                                                 %          
    for j=1:length(mY)                                                    %
        sensor(j,:) = sensor(j,:) - mY(j);
    end
    %Renormalize so for each feature, the variance of the first diff is 1.0
    vY = var((sensor'));     %Hongmin Wu:  varance for each dim

    for j=1:length(vY)
        sensor(j,:) = sensor(j,:) ./ sqrt(vY(j));
    end 
    cellData{nSeq} = sensor;
end
meanSigma = 5 * cov(sensor');  %If bad segmentation, try values between 0.75 and 5.0 
for i=1:size(meanSigma,1)
    for j=1:size(meanSigma,2)
        if(i~=j) 
            meanSigma(i,j) = 0;
        end
    end
end
end