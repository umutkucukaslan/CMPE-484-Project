function linearVideoInterpolator(inputFilename, outputFrameRate)

% WHAT DOES THIS DO?
% This one uses linear interpolation approach to predict interframe
% instants.
outputFilename = 'sil';

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
    end
    
    while outputTimeInstant < inputTimeInstant2
        weight1 = (inputTimeInstant2 - outputTimeInstant) / (inputPeriod);
        weight2 = (outputTimeInstant - inputTimeInstant1) / (inputPeriod);
        outputFrame = (inputFrame1 .* weight1) + (inputFrame2 .* weight2);
        writeVideo(vOutput,outputFrame);
        outputTimeInstant = outputTimeInstant + outputPeriod;
        disp(outputTimeInstant);
    end
end
close(vOutput);
end