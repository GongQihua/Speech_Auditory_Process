recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, 2);
disp('End of Recording.');

play(recObj);

myRecording = getaudiodata(recObj);

plot(myRecording);

filename = 'Roox/roox10.wav'; 
audiowrite(filename,myRecording,8000);