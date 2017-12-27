function videoInterpolatorWithDeformation(inputFilename, outputFrameRate)

outputFilename = 'sil';
medFiltSize = [5 5];

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
        displacementField = imregdemons(moving, fixed, [20 20 20], 'DisplayWaitbar', 0, 'AccumulatedFieldSmoothing', 1);
%         displacementField(:,:,1) = medfilt2(displacementField(:,:,1), medFiltSize);
%         displacementField(:,:,2) = medfilt2(displacementField(:,:,2), medFiltSize);
    end
    
    while outputTimeInstant < inputTimeInstant2
        weight = (outputTimeInstant - inputTimeInstant1) / (inputPeriod);
        outputFrame = imwarp(inputFrame1, weight*displacementField, 'Interp', 'cubic');
        writeVideo(vOutput,outputFrame);
        outputTimeInstant = outputTimeInstant + outputPeriod;
        disp(outputTimeInstant);
    end
end
close(vOutput);

end