clear;
clc;
% WHAT DOES THIS DO?
% This one uses displacement field approach to predict interframe instants.

% Read video
tic;
% ===============
% INITIALIZE
inputFilename = 'test dosyalari/MVI_24.MOV';
outputFilename = 'test dosyalari/test_24to30_2_2_20';
outputFrameRate = 30;
% ===============

vInput = VideoReader(inputFilename); %VIDEO READER OBJECT
[audioInput,FsInput] = audioread(inputFilename); %READING AUDIO
audiowrite([outputFilename, '.wav'], audioInput, FsInput); %WRITING AUDIO
vOutput = VideoWriter(outputFilename); %VIDEO WRITIER OBJECT
vOutput.FrameRate = outputFrameRate;
inputPeriod = 1 / vInput.FrameRate;
outputPeriod = 1 / vOutput.FrameRate;

open(vOutput);
vInput.CurrentTime = 0;
inputTimeInstant1 = 0;
inputTimeInstant2 = 0;
outputTimeInstant = 0;
inputFrame1 = [];
inputFrame2 = readFrame(vInput);
writeVideo(vOutput,inputFrame2);
outputTimeInstant = outputTimeInstant + outputPeriod;

while hasFrame(vInput)
    
    if outputTimeInstant > inputTimeInstant2
        inputFrame1 = inputFrame2;
        inputTimeInstant1 = inputTimeInstant2;
        inputFrame2 = readFrame(vInput);
        inputTimeInstant2 = inputTimeInstant2 + inputPeriod;
        fixed = rgb2gray(inputFrame2);
        moving = rgb2gray(inputFrame1);
%         gpuFixed = gpuArray(fixed);
%         gpuMoving = gpuArray(moving);
%         fixedGPU = gpuArray(inputFrame2);
%         movingGPU = gpuArray(inputFrame1);
%         fixedGPU = rgb2gray(fixedGPU);
%         movingGPU = rgb2gray(movingGPU);
        displacementField = imregdemons(moving, fixed, [2 2 20], 'DisplayWaitbar', 0);
    end
    
    while outputTimeInstant < inputTimeInstant2
        weight = (outputTimeInstant - inputTimeInstant1) / (inputPeriod);
        outputFrame = imwarp(inputFrame1, weight*displacementField);
        writeVideo(vOutput,outputFrame);
        outputTimeInstant = outputTimeInstant + outputPeriod;
        disp(outputTimeInstant);
    end
end
close(vOutput);

toc;