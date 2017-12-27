function preprocessingVideos(inputFilename, const)

outputFilename = 'sil';

vInput = VideoReader(inputFilename);
[yInput,FsInput] = audioread(inputFilename);
audiowrite([outputFilename, '.wav'], yInput, FsInput);
vOutput = VideoWriter(outputFilename);
vInput.FrameRate;
vOutput.FrameRate = vInput.FrameRate / const;
open(vOutput);

count = 0;
while hasFrame(vInput)
    videoFrame = readFrame(vInput);
    if mod(count,const)==0
        writeVideo(vOutput,videoFrame);
    end
    count = count + 1;
end
close(vOutput);

end